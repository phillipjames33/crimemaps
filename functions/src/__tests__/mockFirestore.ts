/**
 * Lightweight in-memory Firestore mock for unit-testing Cloud Functions handlers
 * without requiring a running Java emulator.
 */

interface StoredDoc {
  data: Record<string, unknown>;
}

export class InMemoryFirestore {
  private readonly store = new Map<string, StoredDoc>();
  private autoSeq = 0;

  getCollectionMap(collectionPath: string): Map<string, Record<string, unknown>> {
    const out = new Map<string, Record<string, unknown>>();
    const prefix = `${collectionPath}/`;
    for (const [key, value] of this.store.entries()) {
      if (key.startsWith(prefix)) {
        out.set(key.slice(prefix.length), structuredCloneSafe(value.data));
      }
    }
    return out;
  }

  seedDoc(path: string, data: Record<string, unknown>): void {
    this.store.set(path, { data: structuredCloneSafe(data) });
  }

  getDoc(path: string): Record<string, unknown> | undefined {
    const doc = this.store.get(path);
    return doc === undefined ? undefined : structuredCloneSafe(doc.data);
  }

  collection(name: string) {
    return {
      doc: (id?: string) => {
        const docId = id ?? `auto_${++this.autoSeq}`;
        const path = `${name}/${docId}`;
        return this.makeDocRef(path, docId);
      },
    };
  }

  async getAll(...refs: Array<{ path: string; id: string }>) {
    return refs.map((ref) => this.readSnapshot(ref.path, ref.id));
  }

  batch() {
    const ops: Array<() => void> = [];
    return {
      set: (
        ref: { path: string },
        data: Record<string, unknown>,
        options?: { merge?: boolean },
      ) => {
        ops.push(() => this.writeDoc(ref.path, data, options?.merge === true));
      },
      update: (ref: { path: string }, data: Record<string, unknown>) => {
        ops.push(() => this.updateDoc(ref.path, data));
      },
      commit: async () => {
        for (const op of ops) op();
      },
    };
  }

  async runTransaction<T>(
    fn: (tx: {
      get: (ref: { path: string; id: string }) => Promise<ReturnType<InMemoryFirestore['readSnapshot']>>;
      set: (ref: { path: string }, data: Record<string, unknown>, options?: { merge?: boolean }) => void;
      update: (ref: { path: string }, data: Record<string, unknown>) => void;
    }) => Promise<T>,
  ): Promise<T> {
    const pending: Array<() => void> = [];
    const tx = {
      get: async (ref: { path: string; id: string }) => this.readSnapshot(ref.path, ref.id),
      set: (ref: { path: string }, data: Record<string, unknown>, options?: { merge?: boolean }) => {
        pending.push(() => this.writeDoc(ref.path, data, options?.merge === true));
      },
      update: (ref: { path: string }, data: Record<string, unknown>) => {
        pending.push(() => this.updateDoc(ref.path, data));
      },
    };
    const result = await fn(tx);
    for (const op of pending) op();
    return result;
  }

  asFirestore(): FirebaseFirestore.Firestore {
    return this as unknown as FirebaseFirestore.Firestore;
  }

  private makeDocRef(path: string, id: string) {
    return {
      id,
      path,
      get: async () => this.readSnapshot(path, id),
      set: async (data: Record<string, unknown>, options?: { merge?: boolean }) => {
        this.writeDoc(path, data, options?.merge === true);
      },
      update: async (data: Record<string, unknown>) => {
        this.updateDoc(path, data);
      },
    };
  }

  private readSnapshot(path: string, id: string) {
    const existing = this.store.get(path);
    return {
      id,
      exists: existing !== undefined,
      data: () => (existing === undefined ? undefined : structuredCloneSafe(existing.data)),
    };
  }

  private writeDoc(path: string, data: Record<string, unknown>, merge: boolean): void {
    const existing = this.store.get(path);
    if (merge && existing !== undefined) {
      this.store.set(path, {
        data: { ...existing.data, ...structuredCloneSafe(data) },
      });
    } else {
      this.store.set(path, { data: structuredCloneSafe(data) });
    }
  }

  private updateDoc(path: string, data: Record<string, unknown>): void {
    const existing = this.store.get(path);
    if (existing === undefined) {
      throw new Error(`Document ${path} does not exist`);
    }
    this.store.set(path, {
      data: { ...existing.data, ...structuredCloneSafe(data) },
    });
  }
}

function structuredCloneSafe<T>(value: T): T {
  if (value === null || typeof value !== 'object') return value;
  if (value instanceof Date) return new Date(value.getTime()) as unknown as T;
  if (Array.isArray(value)) return value.map((v) => structuredCloneSafe(v)) as unknown as T;
  // Preserve class instances like GeoPoint with own properties
  const proto = Object.getPrototypeOf(value) as object | null;
  if (proto !== Object.prototype && proto !== null) {
    return value;
  }
  const copy: Record<string, unknown> = {};
  for (const [k, v] of Object.entries(value as Record<string, unknown>)) {
    copy[k] = structuredCloneSafe(v);
  }
  return copy as T;
}
