using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Pool;

namespace Jenga3DModule.Scripts.Runtime.Utils
{
    public class ExtendedObjectPool<T> where T : class
    {
        private readonly ObjectPool<T> pool;

        private readonly List<T> activeItems = new List<T>();

        private readonly Action<T> onGet;
        private readonly Action<T> onRelease;
        private readonly Action<T> onDestroy;

        public ExtendedObjectPool(Func<T> createFunc, Action<T> onGet, Action<T> onRelease, Action<T> onDestroy,
            bool collectionCheck = true, int defaultCapacity = 10, int maxSize = 10000, bool fillToCapacity = false)
        {
            this.onGet = onGet;
            this.onRelease = onRelease;
            this.onDestroy = onDestroy;
            pool = new ObjectPool<T>(createFunc, HandleGetItem, HandleReleaseItem, HandleDestroyItem, collectionCheck,
                defaultCapacity,
                maxSize);

            if (fillToCapacity && defaultCapacity > 0)
            {
                for (var i = 0; i < defaultCapacity; i++)
                {
                    Get();
                }

                ReleaseAll();
            }
        }

        private void HandleDestroyItem(T obj)
        {
            activeItems.Remove(obj);
            onDestroy?.Invoke(obj);
        }

        private void HandleReleaseItem(T obj)
        {
            activeItems.Remove(obj);
            onRelease?.Invoke(obj);
        }

        private void HandleGetItem(T obj)
        {
            activeItems.Add(obj);
            onGet?.Invoke(obj);
        }

        public IReadOnlyList<T> GetActiveItems()
        {
            return activeItems;
        }

        public T Get()
        {
            return pool.Get();
        }

        public ExtendedPooledObject<T> GetPooled()
        {
            var item = pool.Get();
            return new ExtendedPooledObject<T>(this, item);
        }

        public void Release(T item)
        {
            if (activeItems.Contains(item) == false)
            {
                return;
            }

            ReleaseUnchecked(item);
        }

        public void ReleaseUnchecked(T item)
        {
            try
            {
                pool.Release(item);
            }
            catch (Exception ex) // Already released.
            {
                Debug.LogException(ex);
            }
        }

        public void DestroyAll()
        {
            pool.Clear();
        }

        public void ReleaseAll()
        {
            var activeCache = new List<T>(activeItems);
            foreach (var item in activeCache)
            {
                Release(item);
            }
        }

        public bool Contains(T item) => activeItems != null && activeItems.Contains(item);

        public int CountAll => pool.CountAll;
        public int CountActive => pool.CountActive;
        public int CountInactive => pool.CountInactive;
    }
}