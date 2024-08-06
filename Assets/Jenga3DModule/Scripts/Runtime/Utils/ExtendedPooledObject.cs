using System;

namespace Jenga3DModule.Scripts.Runtime.Utils
{
    public struct ExtendedPooledObject<T> : IDisposable where T : class
    {
        private readonly ExtendedObjectPool<T> _pool;

        public readonly T Item;

        public ExtendedPooledObject(ExtendedObjectPool<T> pool, T item)
        {
            this._pool = pool;
            this.Item = item;
        }

        public void Dispose()
        {
            _pool?.Release(Item);
        }
    }
}