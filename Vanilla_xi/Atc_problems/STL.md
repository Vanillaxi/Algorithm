[TOC]

# multiset

https://atcoder.jp/contests/abc448/tasks/abc448_c

O(n log n + q log n)

```c++
void solve() {
    int n,q;
    cin>>n>>q;
    vector<int> a(n+1);
    multiset<int> s;
    for (int i=1;i<=n;i++) {
        cin>>a[i];
        s.insert(a[i]);
    }

    while (q--) {
        int k;
        cin>>k;
        vector<int> b(k+1);
        for (int i=1;i<=k;i++) {
            int x;
            cin>>x;
            b[i]=a[x];
        }

        for (auto i:b) s.extract(i);
        cout<<*s.begin()<<'\n';
        for (auto i:b) s.insert(i);
    }
}
```