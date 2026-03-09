[TOC]

# 均摊

https://codeforces.com/contest/2207/problem/B

* 闪n次，我们贪心使用均摊，至少均摊 min(m,n+1) 个，因为他闪亮会夺走n个max，我们最好能有n+1个max,（这些max当然是由均摊得来的）
  * 要是m<n+1,那我们就均摊m个吧，每次都加在min，闪max
  * 这时候，我们还得维护 s.size < min (m,cnt+1) , cnt就是还剩的操作次数，这时候，我们得 s.insert(0);

* 用multiset 实现

```c++
    int n,m,l;
    cin>>n>>m>>l;
    vector<int> vis(l+1);
    for (int i=1;i<=n;i++) {
        int x;
        cin>>x;
        vis[x]=1;
    }

    multiset <int> s;
    for (int i=1;i<=min(m,n+1);i++) {//保证删完之后还有
        s.insert(0);
    }

    int cnt=n;
    for (int i=1;i<=l;i++) {
        auto it=s.begin();
        int x=*it+1;
        s.erase(it);
        s.insert(x);

        if (vis[i]) {
            auto jt=prev(s.end());
            s.erase(jt);
            cnt--;

            if (s.size()<min(m,cnt+1)) {
                s.insert(0);
            }
        }
    }

    auto it=prev(s.end());
    cout<<*it<<'\n';

```

