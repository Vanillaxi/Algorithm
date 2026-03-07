# 图论

[TOC]

# 存图

## 邻接表

> 1.遍历是否存在从 u 到v 的边(这里是有向的）
> 2.遍历点 u 的所有出边
> 3.遍历整张图

```c++
int n,m ;
vector<vector<int>> adj;
vector<bool> vis;

//遍历是否存在从 u 到v 的边，一般用于有向图
bool find_edge(int u,int v)  {
    for  (int i=0;i<adj[u].size();i++)  {
        if  (adj[u][i]==v) return true;
    }
    return false;
}
//遍历原始起点的出边
void dfs(int u)  {
    if  (vis[u]) return; vis[u]=true;
    for  (int i=0;i<adj[u].size();i++)  {
        int v = adj[u] [i];
        dfs(v);
    }
}

void solve()  {
    cin>>n>>m ;
    adj.resize(n+1);
    vis.resize(n+1);

    for  (int i=1;i<=m;i++)  {
        int u,v;
        cin>>u>>v;
        adj[u].push_back(v);
    }
}
```





## 例题

### 度数

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251207095244652.png" alt="image-20251207095244652" style="zoom: 50%;" align="left"/>

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251207095338205.png" alt="image-20251207095338205" style="zoom:50%;" align="left" />

目标：（n=2，无需讨论），整出n-1个子叶节点，注意到，每次从非子叶节点上操作可出来一个子叶节点就是它自己，而其他节点的“子叶性质”不变，因此需要k:非子叶节点数，`ans=n-1-k`，
接下来随便输出两个非子叶节点即可





# 图上搜索

## DFS

用 stack 存储，遍历每个顶点

```c++
vector<vector<int>> adj;
vector<bool> vis;

void dfs(int x)  {
    stack<int> st;
    st.push(x) ;
    vis[x]=true;

    while  (!st.empty ())  { int u=st.top (); st.pop ();
        for  (int v: adj[u])  {
            if  (vis[v]) continue; vis[v]=true;
            st.push(v); }
    }
}
```



## BFS

```c++
void bfs(int x)  {
    queue<int> q;
    q.push(x);
    vis[x]=true;
    dis[x]=0;
    fa[x]=-1;
    while  (!q.empty ())  {
        int u=q.front() ;
        q.pop ();
        for  (auto v:adj[u])  {
            if  (!vis[v])  {
                vis[v]=true;
                dis[v]=dis[u]+1;
                fa[v]=u;
                q.push(v);
            }
        }
    }
}
```



## 染色

### 基环树

[F-小红的基环树染色构造_牛客周赛 Round 126](https://ac.nowcoder.com/acm/contest/126636/F)

就是n个点，n条边，3种颜色,染色，相邻不同

* 关键在找环，染环，染树



```c++
    vector<int> ring(n+1,1);
    queue<int> q;
    for (int i=1;i<=n;i++) {
        if (deg[i]==1) q.push(i);
    }

//这里用topo找环很好用
    while(!q.empty()) {
        int u=q.front();
        q.pop();
        ring[u]=0;

        for (int v:adj[u]) {
            if (deg[v]>1) {
                deg[v]--;
                if (deg[v]==1) q.push(v);
            }
        }
    }

    vector<int> col(n+1);
    vector<int> row;
    int st=0;
    for (int i=1;i<=n;i++) {
        if (ring[i]) {
            st=i;
            break;
        }
    }

    //出环
    int cur=st,last=-1;
    row.push_back(st);
    while (true) {
        bool ok=false;
        for (int v:adj[cur]) {
            if (!ring[v]||v==last||v==st) {
                ok=false;
            }else {
                ok=true;
                last=cur;
                cur=v;
                row.push_back(cur);
                break;
            }
        }

        if (!ok) break;
    }

    //染环
    int len=row.size();
    for (int i=0;i<row.size();i++) {
        int x=row[i];
        if (i&1) col[x]=2;
        else col[x]=1;
        //cerr<<x<<" ";
    }

    if (len&1) col[row[len-1]]=3;

    //染树
    auto dfs=[&](auto &&self,int u,int f)->void {
        for (int v:adj[u]) {
            if (v==f||ring[v]) continue;
            if (col[u]==1) col[v]=2;
            else col[v]=1;
            self(self,v,u);
        }
    };

    for (int i:row) {//在环上的点遍历
        dfs(dfs,i,0);
    }
```





# 树上问题

## 树上DFS

```c++
int n,d,ans;
vector<int> G[mxn],dis;

//建图
void build(int u,int v)  {
    G[u].push_back(v) ;
    G[v].push_back(u);
}
//dfs
void dfs(int u,int f)  {//需要当前节点及其父节点
    if  (dis[u]<=d) ans++;//合条件
    for  (int i=0;i<G[u].size();i++)  {
        int v=G[u][i];
        if  (v==f) continue;//跳过父节点dis[v]=dis[u]+1;//记录距离
        dfs(v,u);
    }
}

void solve()  {
    cin>>n>>d ;
    dis.resize(n+1);
    for  (int i=1;i<n;i++)  {
        int u,v;
        cin>>u>>v;
        build(u,v);
    }
    dfs(1,0);
    cout<<ans-1<<'\n';//有可能要去掉第一个点
}
```



## 树上BFS

```c++
int n,d,ans;
vector<int> G[mxn],dis,fa;//记得要设一个父节点数组进行记录

//建图
void build(int u,int v)  {
    G[u].push_back(v) ;
    G[v].push_back(u);
}

void bfs(int x)  { queue<int> q ;
    q.push(x) ;
    while(!q.empty ())  {
        int u=q.front() ;
        q.pop ();
        if  (dis[u]<=d) ans++;

        for  (int i=0;i<G[u].size();i++) {
            int v=G[u][i] ;
            if  (v==fa[u]) continue;
            fa[v]=u ;
            dis[v]=dis[u]+1 ;
            q.push(v) ;
        }
    }
}

void solve()  {
    cin>>n>>d ;
    dis.resize(n+1) ;
    fa.resize(n+1) ;
    for  (int i=1;i<n;i++)  {
        int u,v ;
        cin>>u>>v ;
        build(u,v);
    }
    bfs(1) ;
    cout<<ans-1<<'\n';//减起点，依题意
}
```



## 树的直径

### 无权

[B4016 树的直径 - 洛谷](https://www.luogu.com.cn/problem/B4016)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251223210431049.png" alt="image-20251223210431049" style="zoom:33%;" align="left"/>

* 两次dfs，先任选1个点A,dfs找出离他最远的点B，再对B，dfs求出离他最远的点C，直径=BC



```c++
void dfs(int u) {
    for (int v:adj[u]) {
        if (v==fa[u]) continue;
        fa[v]=u;
        dis[v]=dis[u]+1;//有权的话，改改这里的1，开个pair
        dfs(v);
    }
}
```





## 树形DP

感觉最重要的是一种状态转移的思想，怎么转，怎么维护

### 例题

[F-小红的⑨_牛客周赛 Round 117](https://ac.nowcoder.com/acm/contest/121300/F)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251207102033032.png" alt="image-20251207102033032" style="zoom:33%;" align="left"/>

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251207102107985.png" alt="image-20251207102107985" style="zoom:33%;" align="left"/>



```c++
void solve() {
    constexpr int k=9;
    int n;
    cin>>n;
    vector<vector<int>> adj(n+1,vector<int>());
    for (int i=1;i<n;i++) {
        int u,v;
        cin>>u>>v;
        adj[u].emplace_back(v);
        adj[v].emplace_back(u);
    }

    vector<int>order,fa(n+1);
    vector<vector<int>> down(n+1,vector<int>(k+1));
    vector<vector<int>> up(n+1,vector<int>(k+1));
    vector<i64>all(k+1);
    vector<i64> ans(n+1);

    stack<int> st;
    st.push(1);
    while (!st.empty()) {
        int u=st.top();
        st.pop();
        order.emplace_back(u);
        for (int v:adj[u]) {
            if (v==fa[u]) continue;
            fa[v]=u;
            st.push(v);
        }
    }

    for (int i=n-1;i>=0;i--) {
        int u=order[i];
        down[u][0]=1;
        for (int v:adj[u]) {
            if (v==fa[u]) continue;
            for (int d=1;d<=k;d++) {
                down[u][d]+=down[v][d-1];
            }
        }
    }

    for (int u:order) {
        for (int d=1;d<=k;d++) {
            all[d]=up[u][d]+down[u][d];
        }
        ans[u]=all[k];

        for (int v:adj[u]) {
            if (v==fa[u]) continue;
            up[v][1]=1;
            for (int d=2;d<=k;d++) {
                up[v][d]=all[d-1]-down[v][d-2];
            }
        }
    }

   for (int i=1;i<=n;i++) {
       cout<<ans[i]<<" \n"[i==n];
   }

}
```



[P1122 最大子树和 - 洛谷](https://www.luogu.com.cn/problem/P1122)



### 距离深度

[P1131 [ZJOI2007\] 时态同步 - 洛谷](https://www.luogu.com.cn/problem/P1131)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20260103160949178.png" alt="image-20260103160949178" style="zoom:50%;" align="left"/>



<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20260103161251623.png" alt="image-20260103161251623" style="zoom:33%;" align="left"/>

* 显然所有子节点的深度得调整到初始树的max，然后越在根处那里调越划算，

我们要从rt开始dfs,   自下而上的计算dis[u],即以u为根节点的最大深度，接着u这里 ans+=dis[u]-(dis[v]+w);  (w是uv的边权)



### 状态设计

#### 01状态型

[P1352 没有上司的舞会 - 洛谷](https://www.luogu.com.cn/problem/P1352)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251209234712166.png" alt="image-20251209234712166" style="zoom:33%;" align="left"/>

```c++
void dfs(int x) {
    for (int y: adj[x]) {
        dfs(y);
        dp[1][x]+=dp[0][y];
        dp[0][x]+=max(dp[1][y],dp[0][y]);
    }
}
```



#### 多重状态覆盖半径型

[P2279 [HNOI2003\] 消防局的设立 - 洛谷](https://www.luogu.com.cn/problem/P2279)

dp做法

```c++
int n;
vector<vector<int>> adj;
vector<int> fa;
vector<vector<int>> dp;

void dfs(int u) {
    int sum2=0,sum3=0;//待会用容斥
    for (int v:adj[u]) {
        if (v==fa[u]) continue;
        fa[v]=u;
        dfs(v);
        sum2+=dp[v][2];
        sum3+=dp[v][3];
    }

    if (adj[u].empty()) {
        dp[u][0]=1;
        dp[u][1]=1;
        dp[u][2]=1;
        return;
    }

    dp[u][0]=1,dp[u][1]=inf,dp[u][2]=inf;
    for (int v:adj[u]) {
        if (v==fa[u]) continue;
        dp[u][0]+=dp[v][4];//向上2层，下面的都可覆盖
        dp[u][1]=min(dp[u][1],dp[v][0]+sum3-dp[v][3]);//向上1层，下面的都可以覆盖
        dp[u][2]=min(dp[u][2],dp[v][1]+sum2-dp[v][2]);//从自己开始，下面的都可以覆盖
        dp[u][3]+=dp[v][2];//向下1层，下面的都可以覆盖
        dp[u][4]+=dp[v][3];//向下2层，下面的都可以覆盖
    }

    for (int i=1;i<5;i++) {//记住这5个状态存在包含关系
        dp[u][i]=min(dp[u][i],dp[u][i-1]);
    }
}

void solve() {
    cin>>n;
    fa.resize(n+1);
    adj.resize(n+1);
    dp.resize(n+1,vector<int>(5));

    for (int i=2;i<=n;i++) {
        int x;
        cin>>x;
        adj[x].push_back(i);
        adj[i].push_back(x);
    }

    dfs(1);
    cout<<dp[1][2]<<'\n';
}
```



贪心做法 (可推广至覆盖半径为k)

* 自下而上，搜到没有覆盖的点，就给他的祖父建消防站，那么他的父亲/祖父是消防站的话比较容易判断自己是否被覆盖，如果是兄弟的话，其实通过dis[父亲/祖父] ，可以判断出来

```c++
void solve() {
    int n;
    cin>>n;
    vector<int> a(n+1),f(n+1),dis(n+1),d(n+1);
    for (int i=2;i<=n;i++) {
        cin>>f[i];
        d[i]=d[f[i]]+1;//记录深度
    }

    for (int i=0;i<=n;i++) {
        a[i]=i;
        dis[i]=n;//距离自己最近的消防站的距离
    }

    sort(a.begin()+1,a.end(),[&](auto x,auto y) {//按深度对节点排序
       return d[x]>d[y];
    });

    int ans=0;
    for (int i=1;i<=n;i++) {
        int x=a[i],y=f[x],z=f[y];
        dis[x]=min({dis[x],dis[y]+1,dis[z]+2});
        if (dis[x]>2) {
            ans++;
            dis[z]=0;
            dis[f[z]]=min(dis[f[z]],1);
            dis[f[f[z]]]=min(dis[f[f[z]]],2);
        }
    }
    cout<<ans<<'\n';
}
```



### **树形背包**

#### 01背包

限制了你选的边数，求max val

//负边权容易失效，建议再读题，看看思路有没有错，是什么背包

[P2015 二叉苹果树 - 洛谷](https://www.luogu.com.cn/problem/P2015)



```c++
void dfs(int u) {
    for (auto [v,w]: adj[u]) {
        if (v==fa[u]) continue;
        fa[v]=u;
        dfs(v);
        //对于子树v
        for (int i=q;i>=1;i--) {//这里的倒序其实就是01背包的思想，防止重复选择子树v（或子树v的边）
            for (int j=i-1;j>=0;j--) {//也可以正序
                dp[u][i]=max(dp[u][i],dp[v][j]+dp[u][i-j-1]+w);
            }
        }
    }
}
```



如果是一片森林，那就建超级源点，把那些没有父亲的孩子的父亲记为0

[P2014 [CTSC1997\] 选课 - 洛谷](https://www.luogu.com.cn/problem/P2014)



#### 分组背包

[P1273 有线电视网 - 洛谷](https://www.luogu.com.cn/problem/P1273)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20260107113726685.png" alt="image-20260107113726685" style="zoom:50%;" align="left"/>



* 其实跟01背包很像，不同的就是`dp[根][叶子数]`，只要处理好叶子那些状态的初始化，设好状态即可

```c++
int n,m;
vector<vector<pair<int,int>>> adj;
vector<int> val,fa,siz;//siz记录他的子树有多少个叶子
vector<vector<int>> dp;

void dfs(int u) {
    if (u>n-m) {
        dp[u][0]=0;
        dp[u][1]=val[u];
        siz[u]=1;
        return ;
    }

    dp[u][0]=0;

    for (auto [v,w]:adj[u]) {
        if (v==fa[u]) continue;
        fa[v]=u;

        dfs(v);
        siz[u]+=siz[v];

        for (int j=siz[u];j>=0;j--) {
            for (int k=min(siz[v],j);k>=0;k--) {//注意要取min
                dp[u][j]=max(dp[u][j],dp[u][j-k]+dp[v][k]-w);
            }
        }
    }
}
```







### 树的重心

* 即找一个点使得它到其余所有节点距离之和最短
* 同理，题目也可改为max



#### 无权

[P1395 会议 - 洛谷](https://www.luogu.com.cn/problem/P1395)

[P3478 [POI 2008\] STA-Station - 洛谷](https://www.luogu.com.cn/problem/P3478)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20260102221727885.png" alt="image-20260102221727885" style="zoom:40%;" align="left"/>

* 留意那个换根公式

* 那个以1为根，是我们自己想这样的，你就想这是无向图，直接令1的出边全指向son

```c++
    vector<int> fa(n+1),siz(n+1),dis(n+1);
//确定树上的父子关系，并得到每一棵小树的size，以及待会换根要用的一个dis[1]
    function<void(int,int)> dfs = [&](int u,int st) {
        siz[u]=1;//自己也是自己子树的成员
        for (int v:adj[u]) {
            if (v==fa[u]) continue;
            fa[v]=u;
            dfs(v,st+1);
            siz[u]+=siz[v];
        }
        dis[1]+=st;//以1为root记录距离
    };

//计算以每个点为根的dis
    function <void(int)> fd=[&](int u) {
        for (int v:adj[u]) {
            if (v==fa[u]) continue;
            dis[v]=dis[u]+(n-siz[v])-siz[v];//换根公式
            fd(v);
        }
    };

    dfs(1,0);
    fd(1);
```



#### 有权

[P1364 医院设置 - 洛谷](https://www.luogu.com.cn/problem/P1364)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20260102222117007.png" alt="image-20260102222117007" style="zoom:50%;" align="left"/>

```c++
void dfs(int u,int st) {
    siz[u]=w[u];//变为自己的权值
    for (int v:adj[u]) {
        if (v==fa[u]) continue;
        fa[v]=u;
        dfs(v,st+1);
        siz[u]+=siz[v];
    }
    dis[1]+=st*w[u];//st是u到1的距离，再乘以权w[u]
}

void fd(int u) {
    for (int v:adj[u]) {
        if (v==fa[u]) continue;
        dis[v]=dis[u]+siz[1]-2*siz[v];
        fd(v);
    }
}
```



### 倍增+floyd

[P1613 跑路 - 洛谷](https://www.luogu.com.cn/problem/P1613)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20260103132851933.png" alt="image-20260103132851933" style="zoom:45%;" align="left"/>



* 很明显的倍增，`dp[i][j][k]`记录从点 i 到点 j 是否有长度为2^k 的路，

怎么去转移呢 

```c++
    for (int i=1;i<=30;i++) {
        for (int j=1;j<=n;j++) {//中转站
            for (int k=1;k<=n;k++) {//起点
                for (int l=1;l<=n;l++) {//终点
                    if (dp[k][j][i-1]&&dp[j][l][i-1]) {//有2^(i-1) 的就可以转到 2^k
                        dp[k][l][i]=1;
                        dis[k][l]=1;
                    }
                }
            }
        }
    }
```



### 距离

* 其实不是那种显示的dp,但却用了一种转移的思想

[E-Flower_Rainbow_and_Game_牛客小白月赛127](https://ac.nowcoder.com/acm/contest/126634/E)

* 这里的边贡献法，算出所有两两组合的点的距离和，必须掌握！！！
* 然后就是容斥，减一下了

```c++
    i64 ans=0;
    vector<i64> siz(n+1,1),dep(n+1);
    //先算出两两间的距离，用边贡献法,里面的siz*外面的siz
    auto dfs=[&](auto &&self,int u,int p)->void {
        for (auto v:adj[u]) {
            if (v==p) continue;
            dep[v]=dep[u]+1;
            self(self,v,u);
            ans=(ans+siz[v]*(n-siz[v])%mod)%mod;
            siz[u]+=siz[v];
        }
    };

    dfs(dfs,1,0);

    //删去与他深度相关的贡献，容斥一下
    vector<i64> dis=dep;//（包括自己在内）他的子树中的所有节点的深度之和
    auto dfs2=[&](auto &&self,int u,int p)->void {
        for (auto v:adj[u]) {
            if (v==p) continue;
            self(self,v,u);
            dis[u]+=dis[v];
            ans-=dis[v]-dep[u]*siz[v];//先删掉v到u的距离，注意这是一个整体才好理解，别分开想
            ans+=siz[v];//以u为祖先，改为1
            //祖先对
            //注意现在遍历的是u-v,所以我们是以u为祖先的啦，
            //而且不用担心前面的祖先会漏算，dfs自下而上，会算到的，不过是现在在搞以u为祖先
            //顺序问题
        }
    };

    dfs2(dfs2,1,0);
```





# LCA

最近公共祖先

一定要心中有树，画个图理解，遍历顺序，区间范围st表维护



[P3379 【模板】最近公共祖先（LCA） - 洛谷](https://www.luogu.com.cn/problem/P3379)

```c++
int n,m,r,dn;
vector<vector<int>> adj;
vector<int> dfn;//欧拉序
vector<vector<int>> st;

int get(int x,int y) {
    return dfn[x]<dfn[y]?x:y;
}

void dfs(int u,int f) {
    st[dfn[u]=++dn][0]=f;
    for (int v:adj[u]) {
        if (v!=f) dfs(v,u);
    }
}

int lca(int u,int v) {//找到该区间深度最浅的
    if (u==v) return u;
    u=dfn[u],v=dfn[v];
    if (u>v) swap(u,v);
    int len =__lg(v-u);
    u++;
    return get(st[u][len],st[v-(1<<len)+1][len]);
}



void solve() {
    cin>>n>>m>>r;
    adj.resize(n+1,vector<int>());
    st.resize(n+1,vector<int>(__lg(n)+2));
    dfn.resize(n+1);

    int s=n-1;
    while (s--) {
        int u,v;
        cin>>u>>v;
        adj[u].push_back(v);
        adj[v].push_back(u);
    }

    dfs(r,0);
    int k=__lg(n);//返回二进制的最高位
    for (int j=1;j<=k;j++) {
        for (int i=1;i<=n-(1<<j)+1;i++) {
            st[i][j]=get(st[i][j-1],st[i+(1<<(j-1))][j-1]);
        }
    }

    while (m--) {
        int u,v;
        cin>>u>>v;
        cout<<lca(u,v)<<'\n';
    }

}
```







# 拓扑排序



1.节点数
2.边数
3.有向 or 无向
4.边有权值吗
5.思路

拓扑排序可处理的问题：（先得抽象出图）
1.比赛排名
2.食物链类型的路径数，结合 DP

```c++
void solve() {
    int n,m;
    cin>>n>>m;
    vector<vector<int>> adj(n+1);
    vector<int> in(n+1),out(n+1),cnt(n+1);
    for (int i=1;i<=m;i++) {
        int u,v;
        cin>>u>>v;
        adj[u].push_back(v);
        out[u]++,in[v]++;
    }

    queue<int> q;
    for (int i=1;i<=n;i++) {//找入度为0的点
        if (!in[i]) {
            q.push(i);
            cnt[i]=1;
        }
    }
    while (!q.empty()) {
        int u=q.front();
        q.pop();
        for (int v:adj[u]) {//删除该点，递归操作
            in[v]--;
            cnt[v]+=cnt[u];
            if (!in[v]) q.push(v);
        }
    }

    int ans=0;//找出度为0的点
    for (int i=1;i<=n;i++) {
        if (!out[i]) ans+=cnt[i];
    }

    cout<<ans<<'\n';
}
```



## 例题

### 拓扑排序+二分

> [Problem - D - Codeforces](https://codeforces.com/gym/105586/problem/D)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251207103910902.png" alt="image-20251207103910902" style="zoom:33%;" align="left"/>

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251207103953718.png" alt="image-20251207103953718" style="zoom:33%;" align="left"/>



```c++
void solve() {
    int n,m;
    cin>>n>>m;

    vector<int> a(n+1),in(n+1);
    vector<vector<int>> adj(n+1);
    for (int i=1;i<=n;i++) {
        cin>>a[i];
    }
    for (int i=1;i<=m;i++) {
        int u,v;
        cin>>u>>v;
        adj[u].push_back(v);
        in[v]++;
    }

    for (int i=1;i<=n;i++) {
        if (in[i]) continue;
        adj[0].push_back(i);//这里建超级源点会方便很多
        in[i]++;
    }

    vector<i64>dp(n+1);
    auto check=[&](int k) {
        dp.assign(n+1,0);
        dp[0]=k;
        auto du=in;
        queue<int> q;
        q.push(0);

        while(!q.empty()) {
            int u=q.front();
            q.pop();
            for (int v:adj[u]) {
                if (dp[u]>=a[v]) dp[v]=max(dp[v],dp[u]+a[v]);
                else dp[v]=max(dp[v],2*dp[u]-a[v]);

                du[v]--;
                if (!du[v]) q.push(v);
            }
        }
        return dp[n];
    };

    int l=1,r=1e9;
    while (r-l>1) {
        int mid=(l+r)/2;
        if (check(mid)) r=mid;
        else l=mid;
    }

    if (check(l)) cout<<l<<'\n';
    else cout<<r<<'\n';

}
```



# 最短路

1.多归一 --> 反图
2.被破坏的路贡献，其余贡献0 3.点权-->边权
4.最长路：
（1）spfa,改 max
（2）边权取反 -->最短路
5.建超级源点



## spfa

> 慎用！！！
> 1.在有负环且题中的图没有特质时用，否则用 DIJ
> 2.容易 t

```c++
int n,m,s ;
struct node {
    int to,val;
};
vector<vector<node>> edge(mxn);
vector<int> vis(mxn),cnt(mxn),dis(mxn,inf);

bool spfa()  {
    queue<int> q;
    q.push(s);
    vis[s]=1;
    dis[s]=0;
    while  (!q.empty ())  {
        int u=q.front();
        q.pop ();
        vis[u]=0;
        for  (auto  [x,y]: edge[u])  {
            if  (dis[x]>dis[u]+y)  {//注意顺序，要先判能否更新dis[x]=dis[u]+y ;
                cnt[x]=cnt[u]+1;
                if  (cnt[x]>=n)  {//若要判负环，改为 cnt[x]>bianshu
                    return false;
                }
                if  (!vis[x]) {//在不在 q
                    q.push(x);
                    vis[x]=1;
                }
            }
        }
    }

    return true;
}
```



## dijkstra

> 1.负环无法使用
> 2.用小堆维护，结构体储存
> 3.贪心思想

```c++
   //前面使用vector<vector<pair<int,int>>> 双向存边
	vector<vector<pair<int,int>>> adj(n+1);
    for (int i=0;i<m;i++) {
        int u,v,w;
        cin>>u>>v>>w;
        adj[u].emplace_back(v,w);
        adj[v].emplace_back(u,w);//有向图时开注释
    }

    int st,ed;
    cin>>st>>ed;
    
    vector<int> dis(n+1,inf);
    auto dijkstra=[&](int st) {
        vector<int> vis(n+1);
        priority_queue<pair<int,int>,vector<pair<int,int>>,greater<>> pq;
       
        dis[st]=0;
        pq.emplace(0,st);

        while (!pq.empty()) {
            auto[d,u]=pq.top();
            pq.pop();

            if (vis[u]) continue;//延迟删除
            vis[u]=1;

            for (auto [v,w]:adj[u]) {//松弛
                if (dis[v]>dis[u]+w) {
                    dis[v]=dis[u]+w;
                    pq.emplace(dis[v],v);
                }
            }
        }
    };
```



### 例题

#### 地图形

[D - Teleport Maze](https://atcoder.jp/contests/abc436/tasks/abc436_d)

![image-20251214101918416](C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251214101918416.png)

> .与.建权为1的边，相同的字母也建权为1的边，不过字母穿越只能用一次，（超过一次必定不是最优的），然后松弛就好了

```c++
void solve() {
    int h,w;
    cin>>h>>w;

    vector<vector<char>> mp(h+1,vector<char>(w+1));
    for (int i=1;i<=h;i++) {
        for (int j=1;j<=w;j++) {
            cin>>mp[i][j];
        }
    }

    vector<vector<pair<int,int>>> adj(26);
    for (int i=1;i<=h;i++) {
        for (int j=1;j<=w;j++) {
            if (mp[i][j]>='a'&&mp[i][j]<='z') {
                adj[mp[i][j]-'a'].push_back({i,j});
            }
        }
    }

    vector<vector<i64>> dp(h+1,vector<i64>(w+1,inf));
    vector<int> vis(26);
    queue<pair<int,int>> q;
    q.push({1,1});
    dp[1][1]=0;
    pair<int,int> d[4]={{0,1},{0,-1},{1,0},{-1,0}};

    while (!q.empty()) {
        auto [x,y]=q.front();
        q.pop();
        for (int i=0;i<4;i++) {
            int nx=x+d[i].first,ny=y+d[i].second;
            if (nx>0&&nx<=h&&ny>0&&ny<=w&&mp[nx][ny]!='#') {
                if (dp[nx][ny]>dp[x][y]+1) {
                    dp[nx][ny]=dp[x][y]+1;
                    q.push({nx,ny});
                }
            }
        }

        if (mp[x][y]>='a'&&mp[x][y]<='z'&&vis[mp[x][y]-'a']==0) {
            vis[mp[x][y]-'a']=1;
            for (auto[u,v]:adj[mp[x][y]-'a']) {
                if (dp[u][v]>dp[x][y]+1) {
                    dp[u][v]=dp[x][y]+1;
                    q.push({u,v});
                }
            }
        }
    }

    if (dp[h][w]==inf) cout<<-1<<'\n';
    else cout<<dp[h][w]<<'\n';
}
```



## Floyd

> 少用，慢到爆



### 朴素版 

> 记得初始化`dis[i][i]=0,dis[i][j]=inf;`



```c++
int dis[N][N];//用邻接矩阵，N 要小，不然慢到爆
void flo()  {
    for  (int k=1;k<=n;k++)  {//中转站
        for  (int x=1;x<=n;x++)  {
            for  (int y=1;y<=n;y++)  {
                dis[x] [y]=min(dis[x][y],dis[x][k]+dis[k][y]);
            }
        }
    }   
}
```



### 升级与运用

> 让你慢慢update那个dis

```c++
void flo(int k)  {
    for  (int i=0;i<n;i++)  {
        for  (int j=0;j<n;j++)  {
            dis[i][j]=min(dis[i][j],dis[i][k]+dis[k][j]);
        }
    }
}

int cur=0;
for  (int i=1;i<=q;i++)  {
    int x,y,tt;
    cin>>x>>y>>tt;
    while  (cur<n&&t[cur]<=tt)  {//t[]是点出现时间
        flo(cur) ;
        cur++ ;
    }
    if  (t[x]>tt||t[y]>tt)  {
        cout<<-1<<'\n';
    }else if  (dis[x][y]==inf)  {
        cout<<-1<<'\n';
    }else cout<<dis[x][y]<<'\n';
}
```



# 差分约束

> 1.涉及边权，最短路，先用结构体存边及边权。
> 2.所谓约束，其实就是该点受上一点的约束，再来个边权，即可出图

```c++
int n,m,c;
struct node {
    int to,val;
};

vector<vector<node>> adj;
vector<int> dis,in;

void topo() {
    queue<int> q;
    for (int i=1;i<=n;i++) {
        if (!in[i]) q.push(i);
    }

    while (!q.empty()) {
        int u=q.front();
        q.pop();
        for (auto v: adj[u]) {
            in[v.to]--;
            dis[v.to]=max(dis[v.to],dis[u]+v.val);
            if (!in[v.to]) q.push(v.to);
        }
    }
}

void solve() {
    cin>>n>>m>>c;
    adj.resize(n+1);
    dis.resize(n+1);
    in.resize(n+1);
    for (int i=1;i<=c;i++) {
        int u,v,t;
        cin>>u>>v>>t;
        adj[u].push_back({v,t});
        in[v]++;
    }
    topo();
}
```



# 多源BFS

https://ac.nowcoder.com/acm/contest/120562/J

* 逆向思维：从高点到低点min, 用L 给每个deg用小到大排序桶

* 从deg大到小都跑一次bfs ，就像是火种传播，更新起点



时间复杂度：O(n+m) ,因为每个点dis只会有1次被重置为0，dis 一直在继承上一次  bfs  ,  bfs  那里进队有条件限制，一共只会跑 m次

```c++
    vector<vector<int>> adj(n+1);
    for (int i=1;i<=m;i++) {
        int u,v;
        cin>>u>>v;
        adj[u].push_back(v);
        adj[v].push_back(u);
    }

    vector<vector<int>> deg(n+1),L;
    for (int i=1;i<=n;i++) {
        deg[adj[i].size()].push_back(i);
    }

    for (int i=0;i<=n;i++) {
        if (!deg[i].empty()) {
            L.push_back(deg[i]);
        }
    }

    int k=L.size();
    vector<int> dis(n+1,inf),ans(n+1,-1);
    queue<int> q;
    auto bfs=[&]()-> void {
        while (!q.empty()) {
            int u=q.front();
            q.pop();

            for (int v:adj[u]) {
                if (dis[v]>dis[u]+1) {
                    dis[v]=dis[u]+1;
                    q.push(v);
                }
            }
        }
    };

    for (int i:L[k-1]) {
        dis[i]=0;
        q.push(i);
    }
    bfs();

    for (int i=k-2;i>=0;i--) {
        //比该点高的点已经用完了，该点更新完毕，更新ans
        for (int u:L[i]) {
            if (dis[u]!=inf) {
                ans[u]=dis[u];
            }
        }

        //以该点为起点跑bfs
        for (int u:L[i]) {
            dis[u]=0;
            q.push(u);
        }
        bfs();
    }
```





# 最小生成树

给你一个图，让你选若干边生成一棵树，要求这棵树的边值总和min

prim在稠密图中优，在n=5e4,有n个点可以互相连时，kruskal容易mle

kruskal在稀疏图中优

## kruskal

先按边权从小到大排序，再贪心地依次选权值较小的边，并一次连接，若出现环则跳过此边（用并查集检查），继续搜，直到已使用的边的数量比总点数少一即可

时间复杂度：O(m*(log m))  (m为边数)

```c++
void solve() {
    int n,m;
    cin>>n>>m;
    vector<tuple<int,int,int>> adj;
    adj.reserve(m);

    for (int i=1;i<=m;i++) {
        int u,v,w;
        cin>>u>>v>>w;
        adj.push_back({w,u,v});
    }

    int ans=0,cnt=0;

    vector<int> fa(n+1);
    for (int i=1;i<=n;i++) {
        fa[i]=i;
    }

    auto find=[&](auto &&self,int x)->int {
        return x==fa[x]? x: fa[x]=self (self,fa[x]);
    };

    auto kruskal=[&]() {
        sort(adj.begin(),adj.end());
        for (int i=0;i<m;i++) {
            int eu=find(find ,get<1>(adj[i]));
            int ev=find(find ,get<2>(adj[i]));
            if (eu==ev) continue;

            ans+=get<0> (adj[i]);
            fa[ev]=eu;
            if (++cnt==n-1) break;
        }
    };

    kruskal();
    if (cnt==n-1) cout<<ans<<'\n';
    else cout<<"orz\n";//特判是否连通
}
```



## prim

与dijkstra思路很像，思想：以任意节点为根再找出与之相邻的所有边，再将新节点更新并以此节点作为根继续搜，维护一个数组dis，为已用点与未用点的最短距离

用二叉堆优化后，每次都从最短的距离里找

时间复杂度：O((n+m)*log(n+m))



[P1265 公路修建 - 洛谷](https://www.luogu.com.cn/problem/P1265)

```c++
    //前面使用vector<vector<pair<int,int>>> adj 双向存边
auto prim=[&]() {
        vector<int> dis(n+1,inf);
        vector<int> vis(n+1);

        priority_queue<pair<int,int>,vector<pair<int,int>>,greater<>> pq;
        int ans=0,cnt=0;

        dis[1]=0;
        pq.emplace(0,1);//记住先放d再放v

        while (!pq.empty()&&cnt<n) {
            auto[d,u]=pq.top();
            pq.pop();

            if (vis[u]) continue;
            vis[u]=1;
            ans+=d;
            cnt++;

            for (auto [v,w]:adj[u]) {
                if (dis[v]>w) {
                    dis[v]=w;
                    pq.emplace(w,v);
                }
            }
        }

        if (cnt==n) return ans;
        return -1;
    };
```



# 连通性相关

* 割点，点双连通分量都不需要考虑重边；割边，边双连通分量则需要



## Tarjan

强连通：有向图 G 强连通是指，G 中任意两个结点连通．

强连通分量：极大的强连通子图．

Tarjan就是用于求强连通分量，时间复杂度：O(n+m) 点加边

* 在有向图中，因为要考虑横叉边，所以要用ins
* 无向图则不需要

```c++
//dfn:时间戳，low:当前节点能访问到的最早祖先（包括自己）
//ins:是否在栈中 ,be:属于哪个强连通分量,val:强连通分量的权值

	vector<int> dfn(n+1),low(n+1),ins(n+1),be(n+1),val(n+1);
    stack<int> st;
    int cnt=0,scc=0;//cnt时间戳计数器，scc强连通分量计数器

    auto tarjan=[&](auto &&self,int u)->void {
        dfn[u]=low[u]=++cnt;//首先肯定能返回到自己
        st.push(u);
        ins[u]=1;

        for (int v:adj1[u]) {
            if (!dfn[v]) {//没访问过，一定是树边
                self(self,v);
                low[u]=min(low[u],low[v]);
            }else if (ins[v]) {//访问过且在栈中,构成环
                low[u]=min(low[u],dfn[v]);//这一条可能是u的反祖边
            }
        }

        if (low[u]==dfn[u]) {//u是一个SCC的根，找到第一个SCC
            scc++;
            int x;
            do {//直到栈顶是自己
                x=st.top();st.pop();
                be[x]=scc;
                ins[x]=0;
                val[scc]+=a[x];
            }while (x!=u);
        }
    };
```



## 缩点

> 给定一个 *n* 个点 *m* 条边有向图，每个点有一个权值，求一条路径，使路径经过的点权值之和最大。你只需要求出这个权值和。允许多次经过一条边或者一个点，但是，重复经过的点，权值只计算一次。

 我们先用Tarjan处理环，再重新建图得到DAG，topo就好了



```c++
    vector<int> dfn(n+1),low(n+1),ins(n+1),be(n+1);
    //dfn时间戳，low 当前节点能访问到的最早祖先（包括自己），ins是否在栈中
    stack<int> st;
    int cnt=0;//时间戳计数器

    auto tarjan=[&] (auto &&self,int u) ->void {
        dfn[u]=low[u]=++cnt;//首先肯定能返回到自己
        st.push(u);
        ins[u]=1;

        for (auto v:adj1[u]) {
            if (!dfn[v]) {//没访问过，一定是树边
                self(self,v);
                low[u]=min(low[u],low[v]);
            }else if (ins[v]) {//访问过且在栈中,构成环
                low[u]=min(low[u],dfn[v]);//这一条可能是u的反祖边，因此low[u]未必=be[u]
            }
        }

        if (dfn[u]==low[u]) {//u是一个SCC的根，找到第一个SCC
            int x;
            do {//直到栈顶是自己
                x=st.top();
                st.pop();
                ins[x]=0;
                be[x]=u;
                if (x!=u) a[u]+=a[x];
            }while (x!=u);
        }
    };

    vector<int> in(n+1),dp(n+1);
    auto topo=[&]()->void {
        queue<int> q;
        for (int i=1;i<=n;i++) {
            if (i==be[i]&&!in[i]) {//找到入度为0的点且代表SCC,易漏
                q.push(i);
                dp[i]=a[i];//初始化dp,易忘
            }
        }

        while (!q.empty()) {
            int u=q.front();
            q.pop();
            for (auto v:adj2[u]) {
                dp[v]=max(dp[v],dp[u]+a[v]);
                if (!--in[v]) q.push(v);
            }
        }
    };

    for (int i=1;i<=n;i++) {
        if (!dfn[i]) tarjan(tarjan,i);
    }

    for (int u=1;u<=n;u++) {//缩点
        for (int v:adj1[u]) {
            int x=be[u],y=be[v];
            if (x!=y) {//构建不同SCC之间的边
                adj2[x].push_back(y);
                in[y]++;
            }
        }
    }

    topo();
```





## 割点

无向图，所以儿子--> 父亲的边不处理

无向图里面只有树边和无向边，根据dfn序，你那个点是由谁访问的，那你的父亲就是谁

割点：在连通图中删除了这个点及与其相连的边后，图不连通了（当然你也可以理解为连通分量数增加了）

* case1: 非root  &&  有son  &&  low[son]>=dfn[x] 至少1个即可

* case2: 是root  &&  有>=2个son





<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20260110105413840.png" alt="image-20260110105413840" style="zoom:50%;" />



```c++
    vector<int> dfn(n+1),low(n+1),buc(n+1);//buc用来记录他是不是割点
    int dn=0,cnt=0,rt=0;
    auto tarjan=[&](auto &&self,int u)->void {
        dfn[u]=low[u]=++dn;
        int son=0;
        for (int v:adj[u]) {
            if (!dfn[v]) {
                son++;
                self(self,v);
                low[u]=min(low[u],low[v]);

                if (low[v]>=dfn[u]&&u!=rt) {//case1
                    cnt+=!buc[u];//因为可能其他儿子把这里更新过了
                    buc[u]=1;
                }
            }else {
                low[u]=min(low[u],dfn[v]);
            }
        }

        if (son>=2&&u==rt) {//case2
            cnt+=!buc[u];
            buc[u]=1;
        }
    };

    for (int i=1;i<=n;i++) {
        if (!dfn[i]) {
            rt=i;//关键是我们无法确定他所给的是多少个连通图
            tarjan(tarjan,i);
        }
    }

    cout<<cnt<<'\n';
    for (int i=1;i<=n;i++) {
        if (buc[i]) cout<<i<<" ";
    }
```



## 割边

割边，又称桥：在连通图中删除了这条边后(但不删点)，图不连通了（当然你也可以理解为连通分量数增加了）

* low[y]>dfn[x]



需要考虑重边

```c++
void solve() {
    int n,m;
    cin>>n>>m;
    vector<vector<pair<int,int>>> adj(n+1);//点，点，编号
    vector<pair<int,int>> edge(m+1);
    for (int i=1;i<=m;i++) {
        int u,v;
        cin>>u>>v;
        adj[u].push_back({v,i});
        adj[v].push_back({u,i});
        edge[i]={u,v};//没啥用
    }

    vector<int> dfn(n+1),low(n+1);
    vector<int> bri;
    int dn=0,cnt=0;
    auto tarjan=[&](auto &&self,int u,int eid)->void {
        dfn[u]=low[u]=++dn;

        for (auto [v,id] :adj[u]) {
            if (id==eid) continue;//跳过自己来时的边

            if (!dfn[v]) {
                self(self,v,id);
                low[u]=min(low[u],low[v]);

                if (low[v]>dfn[u]) {
                    bri.push_back(id);
                    cnt++;
                }
            }else  {
                low[u]=min(low[u],dfn[v]);
            }
        }
    };

    for (int i=1;i<=n;i++) {
        if (!dfn[i]) tarjan(tarjan,i,0);//第一次是0
    }

    cout<<cnt<<'\n';
    
    sort(bri.begin(),bri.end());
    for (int i:bri) cout<<i<<' ';
}
```



## 双连通分量

双连通分量其实就是在找一个环，点双是标准环，边双没那么苛刻

* 边双连通具有传递性
* 点双连通不具有传递性



### 点双连通分量

* 在一张连通的无向图中，对于两个点u和v,如果无论删去哪条边（只能删1条）都不能是他们不连通，那我们则称u,v边双连通
* 由边双连通构成的极大子图称为边双连通分量



两个点双至多只有1个公共点，且该点必定为割点，点双里面无该子图的割点



```c++
    vector<int> dfn(n+1),low(n+1);
    vector<vector<int>> ans(n+1);
    stack<int> st;
    int cnt=0,bcc=0;
    auto tarjan=[&](auto &&self,int u,int fa)->void {
        dfn[u]=low[u]=++cnt;
        st.push(u);
        int son=0;

        for (int v:adj[u]) {
            if (!dfn[v]) {
                son++;
                self(self,v,u);
                low[u]=min(low[u],low[v]);

                if (low[v]>=dfn[u]) {//u为割点
                    bcc++;
                    int x;
                    do {
                        x=st.top();
                        st.pop();
                        ans[bcc].push_back(x);
                    }while (x!=v);
                    ans[bcc].push_back(u);//割点属于多个点双，这里别忘了塞进去！！！
                }
            }else if (v!=fa) low[u]=min(low[u],dfn[v]);//反祖边
        }

        if (!fa&&!son) ans[++bcc].push_back(u);//特判孤立点
    };
```



### 边双连通分量

* 在一张连通的无向图中，对于两个点u和v,如果无论删去哪条边（只能删1条）都不能是他们不连通，那我们则称u,v边双连通
* 由边双连通构成的极大子图称为边双连通分量



与求强连通分量很像，只不过强连通分量是缩环，这里不是

需要考虑重边

```c++
    int n,m;
    cin>>n>>m;
    vector<vector<pair<int,int>>> adj(n+1);
    for (int i=1;i<=m;i++) {
        int u,v;
        cin>>u>>v;
        adj[u].push_back({v,i});
        adj[v].push_back({u,i});
    }

    vector<int> dfn(n+1),low(n+1);
    vector<vector<int>> ans(n+1);
    stack<int> st;
    int cnt=0,bcc=0;
    auto tarjan=[&](auto &&self,int u,int eid)->void {
        dfn[u]=low[u]=++cnt;
        st.push(u);

        for (auto [v,id]:adj[u]) {
            if (id==eid) continue;
            if (!dfn[v]) {
                self(self,v,id);
                low[u]=min(low[u],low[v]);
            }else low[u]=min(low[u],dfn[v]);
        }

        if (dfn[u]==low[u]) {
            bcc++;
            int x;
            do {
                x=st.top();
                st.pop();
                ans[bcc].push_back(x);
            }while (x!=u);
        }
    };
```





# 连通块

[E - Minimum Swap](https://atcoder.jp/contests/abc436/tasks/abc436_e)

![image-20251213231552693](C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251213231552693.png)



> 令i,a[i],a[a[i]],.......,构成一个环，只在环上交换，且每次交换得到一个新环，就为最优
>
> 记原来有c个环，则k=n-c,
>
> 对每个环上取两个数的方案数求和即可



# 二分图

* 奇数个点的环不合法
* 边上的两点涂色不同





## 判断二分图+最小染色数

[C - 嘘つきな天使たち](https://atcoder.jp/contests/maximum-cup-2018/tasks/maximum_cup_2018_c)

* 在solve那里遍历dfs前记得`cnt.assign(2,0);ans+=min(cnt[0],cnt[1]);`
* 还有就是图不一定连通



```c++
void dfs(int u,int x) {
    col[u]=x;
    vis[u]=1;
    cnt[x]++;

    for (int v:adj[u]) {
        if (vis[v]&&col[v]==col[u]) {
            flag=0;
            return;
        }

        if (!vis[v]) {
           dfs(v,!col[u]);
        }

        if (!flag) return;
    }
}
```



[P1525 [NOIP 2010 提高组\] 关押罪犯 - 洛谷](https://www.luogu.com.cn/problem/P1525)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251226152126289.png" alt="image-20251226152126289" style="zoom:50%;" align="left"/>



* 本题有多种解法
  * 二分答案 + 二分图  ：让矛盾最大的那一堆构成一个二分图，显然边数越少越容易构图，可以二分
  
    先排序，你要知道自己在二分什么，就是为了找到一个x, 1~x-1冲突 ，其余可以构成二分图,(check用来判断能否构成二分图)  （注意到答案具有单调性，即大于答案x的必能构成二分图）
  
  * 并查集







## 二分图最大匹配

就是把一堆物品分给一群人（但要根据人的喜好分）

* 增广路：未分配点——>未分配路——> 分配路——>......——>未分配路——>未分配点

* 两个未分配点异侧，换而言之就是从未分配点经过交替路到达未分配点
* 增广路上的未分配路=分配路+1

最大分配的二分图必定不存在增广路（取反）

时间复杂度： O(nm) 左部点*边数

```c++
vector<vector<int>> adj;//单向存边，人-物
vector<int> rec,tim;//rec[物]=主人，时间戳，防止（该轮）重边

bool dfs(int u,int t) {
    if (tim[u]==t) return false;
    tim[u]=t;

    for (auto v:adj[u]) {
        if (!rec[v]||dfs(rec[v],t)) {
            rec[v]=u;
            return true;//我们只要找到1条增广路即可
        }
    }
    return false;
}

void solve() {
    int n,m,e;
    cin>>n>>m>>e;
    adj.resize(n+1);
    rec.resize(m+1);
    tim.resize(n+1);

    for (int i=1;i<=e;i++) {
        int u,v;
        cin>>u>>v;
        adj[u].push_back(v);//单向存边，因为我们只需要遍历一侧
    }

    int ans=0;
    for (int i=1;i<=n;i++) {
        if (dfs(i,i)) ans++;
    }

    cout<<ans<<'\n';
}

```



[P1640 [SCOI2010\] 连续攻击游戏 - 洛谷](https://www.luogu.com.cn/problem/P1640)

关键在于要分清楚（或自己确定）左部，右部，然后进行匹配





## 例题

### 状压

[C - Bipartize](https://atcoder.jp/contests/abc427/tasks/abc427_c)

![image-20251225203438869](C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251225203438869.png)



数据足够小，可以枚举 ，O((2^n)*m)，这种题一般都会给小图，纯枚举n个点的涂色方案数，有2^n种，对每种进行分析套上去（用二进制001101），再check有哪些要删的

```c++
void solve() {
    int n,m;
    cin>>n>>m;

    vector<pair<int,int>> adj;
    for (int i=1;i<=m;i++) {
        int u,v;
        cin>>u>>v;
        adj.push_back({u,v});
    }

    int ans=m;
    for (int i=0;i<(1<<n);i++) {
        int cnt=0;
        for (auto[u,v]:adj) {
            if (((i>>u)&1)==((i>>v)&1)) cnt++;
        }
        ans=min(ans,cnt);
    }
    cout<<ans<<'\n';
}
```



