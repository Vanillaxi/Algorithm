# 模拟

[TOC]

# 直接模拟

[问题 - 1846C - Codeforces --- Problem - 1846C - Codeforces](https://codeforces.com/problemset/problem/1846/C)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251208170042965.png" alt="image-20251208170042965" style="zoom:33%;" align="left"/>

> 是的，这题很简单，但这里提供一种优雅的写法, pair

```c++
void solve() {
    int n,m,h;
    cin>>n>>m>>h;

    vector<vector<i64>> t(n,vector<i64>(m));
    vector<pair<i64,i64>> a(n);

    for (int i=0;i<n;i++) {
        for (int j=0;j<m;j++) {
            cin>>t[i][j];
        }
        sort(t[i].begin(),t[i].end());
    }

    for (int i=0;i<n;i++) {
        i64 sum=0,tp=0,ac=0;
        for (int j=0;j<m;j++) {
            if (sum+t[i][j]<=h) {
                sum+=t[i][j];
                tp+=sum;
                ac++;
            }
        }
        a[i]={ac,-tp};//这里很巧妙，直接取反
    }

    int ans=1;
    for (int i=1;i<n;i++) {
        ans+=a[0]<a[i];
    }

    cout<<ans<<'\n';
}
```







# 暴力枚举

[小红杀怪_牛客题霸_牛客网](https://www.nowcoder.com/practice/d337370cc83146ad9a02ea554fd2594b?channelPut=tracker2)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251208144626318.png" alt="image-20251208144626318" style="zoom:33%;" align="left"/>

> 这里我们直接来一个循环0到20表示群攻次数，再来计算剩余所需的单击次数即可，min。
> 其实我们意识到且可以构造数据来说明先单击还是先群攻，在最优顺序下可能只需进行1
> 个 (4 5 3 6) ，但这并不妨碍我们上述做法，因为我们所谓的意识到其实已经改动了cnt
> 群攻，在cnt群攻确定的情况下，单击数就是在灵活，以满足你所谓的不同顺序下的cnt群
> 攻不变



https://ac.nowcoder.com/acm/contest/120566/H

* 直接覆盖，n<2048,每次都用map1记录0~2048那个数可以到达，然后指导map2下一轮的，map2-->map1





# 区间和并

[小sun的假期_牛客题霸_牛客网](https://www.nowcoder.com/practice/e502f7c4ca9e455ab252d2451f5dacb2?channelPut=tracker2)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251208145240724.png" alt="image-20251208145240724" style="zoom:33%;" align="left"/>

```c++
void solve() {
    int n,m;
    cin>>n>>m;

    vector<pair<int,int>> a(m+1);
    for (int i=1;i<=m;i++) {
        int l,r;
        cin>>l>>r;
        a[i]={l,r};
    }

    sort(a.begin()+1,a.end());
    int lr=a[1].second;
    int ans=a[1].first-1;
    for (int i=2;i<=m;i++) {
        if (a[i].first>lr) ans=max(ans,a[i].first-lr);
        lr=max(lr,a[i].second);
    }
    ans=max(ans,n-lr);
    cout<<ans<<'\n';
}
```



# 贪心

[Problem - 4B - Codeforces](https://codeforces.com/problemset/problem/4/B)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251208153015832.png" alt="image-20251208153015832" style="zoom:33%;" align="left"/>

关键在于如何分配每天，首先每天min分配好，再来个`int d=min(sum-l,rr[i]-ll[i]),l`是已有的时间



# 排序

[Problem - 1922B - Codeforces](https://codeforces.com/problemset/problem/1922/B)

![image-20251208161335394](C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251208161335394.png)

> cnt3，2处理就好，但2的话要考虑到前面有多少比自己小的，sum,在查答案的时候的最后一步再更新sum,否则t
> 意思就是sum+=cnti,



# 网格

### 曼哈顿距离

单点改,区间查询

https://ac.nowcoder.com/acm/contest/120564/H

```c++
void solve() {
    int n,m,q;
    cin>>n>>m>>q;
    vector<vector<i64>> a(n,vector<i64>(m));
    for(int i=0;i<n;i++) {
        for(int j=0;j<m;j++) {
            cin>>a[i][j];
        }
    }

    tuple<i64,i64,i64> ans{-inf,-1,-1};
    for (int i=0;i<n;i++) {
        for (int j=0;j<m;j++) {
            i64 cur=0;
            for (int x=max(0,i-2);x<=min(n-1,i+2);x++) {
                for (int y=max(0,j-2);y<=min(m-1,j+2);y++) {
                    if (abs(i-x)+abs(j-y)>2) continue;
                    cur+=a[x][y];
                }
            }
            ans=max(ans,{cur,i,j});
        }
    }

    while (q--) {
        int x,y,z;
        cin>>x>>y>>z;
        x--,y--;
        a[x][y]+=z;

        for (int i=max(0,x-2);i<=min(n-1,x+2);i++) {
            for (int j=max(0,y-2);j<=min(m-1,y+2);j++) {//被影响的点
                i64 cur=0;
                for (int xx=max(0,i-2);xx<=min(n-1,i+2);xx++) {//被影响的点所归属的块
                    for (int yy=max(0,j-2);yy<=min(m-1,j+2);yy++) {
                        if (abs(xx-i)+abs(yy-j)>2) continue;
                        cur+=a[xx][yy];
                    }
                }
                ans=max(ans,{cur,i,j});
            }
        }

        auto [zzz,xxx,yyy]=ans;
        cout<<xxx+1<<" "<<yyy+1<<'\n';
    }
}
```



# 优化

[Problem - D - Codeforces](https://codeforces.com/contest/2185/problem/D)

m次修改，且考虑到重置整个数组，我们可以开一个标记，追踪到上一次重置的时候，减到现在即可





