# 数据结构

[TOC]

# KEY

首先你得知道这道题的思路，这些数据结构只是便于你去优化，

你得知道自己要维护什么，然后考虑用什么数据结构





# 并查集



## 按秩优化



###### 按高度

```c++
vector<int> fa;

int find(int x) {
    if (fa[x]==x) return x;
    return fa[x]=find(fa[x]);
}

void solve() {
    int n,m;
    cin>>n>>m;

    fa.resize(n+1);
    for (int i=1;i<=n;i++) {
        fa[i]=i;
    }

    vector<int> siz(n+1,1);

    while (m--) {
        int opt,x,y;
        cin>>opt>>x>>y;
        x=find(x),y=find(y);
        if (opt==1) {//合并
            if (x==y) continue;
            if (siz[y]<siz[x]) swap(x,y);//合并到y
            if (siz[x]==siz[y]) siz[y]++;
            fa[x]=y;
        }else {//查询
            if (x==y) cout<<"Y\n";
            else cout<<"N\n";
        }
    }

}
```



###### 按集合

```c++
vector<int> fa;

int find(int x) {
    if (fa[x]==x) return x;
    return fa[x]=find(fa[x]);
}

void solve() {
    int n,m;
    cin>>n>>m;

    fa.resize(n+1);
    for (int i=1;i<=n;i++) {
        fa[i]=i;
    }

    vector<int> siz(n+1,1);

    while (m--) {
        int opt,x,y;
        cin>>opt>>x>>y;
        x=find(x),y=find(y);
        if (opt==1) {//合并
            if (x==y) continue;
            if (siz[y]<siz[x]) swap(x,y);//合并到y
            siz[y]+=siz[x];
            fa[x]=y;
        }else {//查询
            if (x==y) cout<<"Y\n";
            else cout<<"N\n";
        }
    }

}
```



###### 结构体

```c++
struct DSU {
    vector<int> f, siz;
    DSU(int n) : f(n+1), siz(n+1, 1) { iota(f.begin(), f.end(), 0); }
    int leader(int x) {
        while (x != f[x]) x = f[x] = f[f[x]];
        return x;
    }
    bool same(int x, int y) { return leader(x) == leader(y); }
    bool merge(int x, int y) {
        x = leader(x);
        y = leader(y);
        if (x == y) return false;
        siz[x] += siz[y];
        f[y] = x;
        return true;
    }
    int size(int x) { return siz[leader(x)]; }
};

void solve() {
    int n,m1,m2;
    cin>>n>>m1>>m2;
    DSU t1(n+1),t2(n+1);
}
```



https://codeforces.com/problemset/problem/1559/D1

* 两个并查集，ans=n-1-max(m1,m2),因为最终必定有一个图会变成一棵树
* 然后就是O(nlog(n)) 的遍历合并了

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20260208161423501.png" alt="image-20260208161423501" style="zoom:10%;" align="left"/>

```c++
    vector<vector<int>> v1(n+1),v2(n+1);
    while (ans) {
        for (int i=1;i<=n;i++) {
            v1[i].clear();
            v2[i].clear();
        }

        for (int i=1;i<=n;i++) {//分类放入（连通块）
            v1[t1.leader(i)].push_back(i);
            v2[t2.leader(i)].push_back(i);
        }

        int i=1,j=1;
        while (true&&ans) {
            while (i<=n&&t1.leader(i)!=i) i++;//找代表点
            while (j<=n&&t2.leader(j)!=j) j++;

            if (i==n+1||j==n+1) break;

            int a=0,b=0,c=0,d=1;
            for (auto x:v1[i]) {//找独立的
                if (!t2.same(x,j)) a=x;
                else c=x;
            }

            for (auto x:v2[j]) {
                if (!t1.same(x,i)) b=x;
                else c=x;
            }

            if (a&&b) {
                cout<<a<<" "<<b<<'\n';
                t1.merge(a,b);
                t2.merge(b,a);//不这样就会re
            }else {//找不到，就需要借助d
                while (t1.same(d,i)||t2.same(d,j)) d++;
                cout<<c<<" "<<d<<'\n';
                t1.merge(c,d);
                t2.merge(c,d);
            }
            ans--;
            i++;
            j++;
        }
    }
```





## 种类并查集

也称拓展域并查集，在模意义下边权和模数都比较小的才用

### 反集（2）

两种关系，就是敌人的敌人是朋友，敌人合并，朋友合并，多个团体

[P1892 [BalticOI 2003\] 团伙 - 洛谷](https://www.luogu.com.cn/problem/P1892)

```c++
    for (int i=1;i<=2*n;i++) {//开二倍，i+n 是i的敌人阵营
        fa[i]=i;
    }

    for (int i=1;i<=m;i++) {
        char c;
        int x,y;
        cin>>c>>x>>y;

        if (c=='F') fa[find(x)]=find(y);//朋友
        else {//敌人
            fa[find(x+n)]=find(y);//用find()保险一点，可以顺便更新，不用就会mle
            fa[find(y+n)]=find(x);
        }
    }
```



[P1525 [NOIP 2010 提高组\] 关押罪犯 - 洛谷](https://www.luogu.com.cn/problem/P1525)

先sort,然后进行判断（如果两对仇敌在一个阵营，那直接输出，break)，否则合并





### 升级版（3）

[P2024 [NOI2001\] 食物链 - 洛谷](https://www.luogu.com.cn/problem/P2024)

A---->B---->C---->A ,A吃B，B吃C，C吃A

```c++
void solve() {
    int n,m;
    cin>>n>>m;
    fa.resize(3*n+1);
    for (int i=1;i<=3*n;i++) {//自己想成1个环，i同类，i+n吃谁，i+n+n,被谁吃
        fa[i]=i;
    }

    int ans=0;
    while (m--) {
        int opt,x,y;
        cin>>opt>>x>>y;
        if (x>n||y>n) {
            ans++;
            continue;
        }

        if (opt==1) {
            if (find(x+n)==find(y)||find(x+n+n)==find(y)) ans++;//查的时候用find,而非fa
            else {
                fa[find(x)]=find(y);//改的时候改祖先，而非x
                fa[find(x+n)]=find(y+n);
                fa[find(x+n+n)]=find(y+n+n);
            }
        }else {
            if (find(x)==find(y)||find(x+n+n)==find(y)) ans++;
            else {
                fa[find(x)]=find(y+n+n);
                fa[find(x+n)]=find(y);
                fa[find(x+n+n)]=find(y+n);
            }
        }

    }
```



## 带权并查集

用种类并查集能解决的，带权并查集也能，可以理解成边权就是拓展域

[P2024 [NOI2001\] 食物链 - 洛谷](https://www.luogu.com.cn/problem/P2024)

```c++
vector<int> fa,re;
int find(int x) {
    if (fa[x]!=x) {
        int root=find(fa[x]);//一定要先调用再 re 再 fa
        re[x]=(re[x]+re[fa[x]])%3;
        fa[x]=root;
    }
    return fa[x];
}

void solve() {
    int n,m;
    cin>>n>>m;
    fa.resize(n+1);
    re.resize(n+1);

    for (int i=1;i<=n;i++) {
        fa[i]=i;
    }

    int ans=0;
    while (m--) {
        int opt,x,y;
        cin>>opt>>x>>y;
        if (x>n||y>n) {
            ans++;
            continue;
        }

        int f1=find(x),f2=find(y);
        if (opt==1) {
            if (f1==f2&&re[x]!=re[y]) ans++;
            if (f1!=f2) {//未合并
                fa[f1]=f2;
                re[f1]=(re[y]-re[x]+3)%3;//这部分画个图会很好理解路径的运算
            }
        }else {
            int rela=(re[x]-re[y]+3)%3;
            if (f1==f2&&rela!=1) ans++;
            if (f1!=f2) {//未合并
                fa[f1]=f2;
                re[f1]=(re[y]-re[x]+1+3)%3;
            }
        }
    }
    cout<<ans<<'\n';
}
```



[P1196 [NOI2002\] 银河英雄传说 - 洛谷](https://www.luogu.com.cn/problem/P1196)

要开个siz

```c++
    while (n--) {
        char opt;
        int x,y;
        cin>>opt>>x>>y;
        int f1=find(x),f2=find(y);
        if (opt=='M') {
            fa[f1]=f2;
            re[f1]+=siz[f2];//直接加到f1那里，因为f1的子节点fa已全部标记为f1，到时候find 的时候会直接跳到f1
            siz[f2]+=siz[f1];
        }else {
            if (f1!=f2) cout<<-1<<'\n';
            else cout<<abs(re[x]-re[y])-1<<'\n';
        }
    }
```



## 逆向思维

[P1197 [JSOI2008\] 星球大战 - 洛谷](https://www.luogu.com.cn/problem/P1197)

删边删点，那就倒序，反着建，离线处理

```c++
    int k;
    cin>>k;
    vector<int> de(k+1),sig(n+1);//一个用来存要拆的点，一个用来标记状态
    for (int i=1;i<=k;i++) {
        int x;
        cin>>x;
        de[i]=x;
        sig[x]=1;//拆了
    }

    vector<int> ans(k+2);
    int tot=n-k;//k次操作后余下的点
    for (int i=1;i<=n;i++) {//看看有没有不用删的边
        if (sig[i]) continue;
        for (int j:adj[i]) {
            if (sig[j]) continue;
            if (find(j)!=find(i)) {//未合并
                fa[find(j)]=find(i);
                tot--;
            }
        }
    }

    ans[k+1]=tot;
    for (int i=k;i>=1;i--) {
        int u=de[i];
        sig[u]=0;//修复
        tot++;//修复一个点就多一个连通块
        for (int v:adj[u]) {//看看能否合并
            if (sig[v]) continue;
            if (find(v)!=find(u)) {
                fa[find(v)]=find(u);
                tot--;
            }
        }
        ans[i]=tot;
    }
```



# ST表

空间：O(nlgn),n很大时（1e5）两个st表容易mle,这时应使用单调队列O(n),线段树O(4n),分块O(n)

> 用于静态查询区间最值，解决RMQ问题

###### 无封装版

```c++
void solve() {
    int n,m;//元素个数，访问次数
    cin>>n>>m;

    vector<int> lg(n+1);
    lg[1]=0;
    for (int i=2;i<=n;i++) {//i对2取对数，再向下取整
        lg[i]=lg[i>>1]+1;
    }

    vector<vector<int>> f(n+1,vector<int>(lg[n]+2));//f[起点][长度]
    for (int i=1;i<=n;i++) {//st表的初始点数据
        cin>>f[i][0];
    }

    //构建st表，类似区间dp
    for (int j=1;j<=lg[n];j++) {//先枚举区间长度
        for (int i=1;i<=n-(1<<j)+1;i++) {//再到起点，减的要+1，加的不用
            f[i][j]=max(f[i][j-1],f[i+(1<<(j-1))][j-1]);//倍增思想
        }
    }

    while (m--){
        //其实我们最想1个区间内搞定，但我们的区间长度是严格限制=2的n次幂
        int x,y;
        cin>>x>>y;
        int len=lg[y-x+1];//向下取整，长度<=我们要的，那只能2个区间了
        cout<<max(f[x][len],f[y-(1<<len)+1][len])<<'\n';
    }
}
```



###### 封装版

```c++
template <typename T>
struct ST {
    vector<vector<T>> st;

    explicit ST(const vector<T> &v): st() {
        u64 len=v.size(),d=bit_width(bit_ceil(len));
        //bit_ceil(len)不小于len的最小2的幂（先log2再加1）
        st.assign(len,vector<T>(d));

        for (int i=0;i<len;i++) st[i][0]=v[i];
        for (int j=1;j<d;j++) {//区间长度
            for (int i=0;i+(1<<(j-1))<len;i++) {
                st[i][j]=T::merge(st[i][j-1],st[i+(1<<(j-1))][j-1]);
            }
        }
    }

    T query(u64 l,u64 r){
        u64 d=bit_width(bit_floor(r-l+1));
        return T::merge(st[l][d-1],st[r-(1<<(d-1))+1][d-1]);
    }

};

struct info {
    i64 val=0;
    static info merge(const info&a,const info&b) {
        return {min(a.val,b.val)};
    }
};

void solve() {
    u64 n,m;
    cin>>n>>m;
    vector<info> a(n+1);
    for (i64 i=1;i<=n;i++) cin>>a[i].val;

    ST<info> st(a);
    while (m--) {
        i64 l,r;
        cin>>l>>r;
        cout<<st.query(l,r).val<<" ";
    }
}
```



# 树状数组

> 树状数组又称二叉索引树，是一种支持单点修改，区间查询的精巧的数据结构，通常用于维护满足结合律和可差分的运算信息

> 对区间进行动态修改和查询







### 单点修改，区间查询

> 树状数组维护前缀和数组

注：我这里update设置的是加数

```c++
constexpr int mxn=5e5+5;
int n,m,s[mxn];

struct BIT {
    int c[mxn];
    int lowbit(int x) {
        return x&-x;
    }

    void update(int x,int k) {
        while (x<=n) {
            c[x]+=k;
            x+=lowbit(x);
        }
    }

    int query(int x) {
        int res=0;
        while (x) {
            res+=c[x];
            x-=lowbit(x);
        }
        return res;
    }

}t;

void solve() {
    cin>>n>>m;
    for (int i=1;i<=n;i++) {
        cin>>s[i];
        t.update(i,s[i]);
    }

    while (m--) {
        int opt,x,y;
        cin>>opt>>x>>y;
        if (opt==1) {
            t.update(x,y);
        }else {
            cout<<t.query(y)-t.query(x-1)<<'\n';
        }
    }
}
```



### 区间修改，单点查询

> 树状数组维护差分数组

```c++
constexpr int mxn=5e5+5;
int n,m,s[mxn];
struct BIT {
    int c[mxn];
    int lowbit(int x) {
        return x&-x;
    }

    void update(int x,int k) {
        while (x<=n) {
            c[x]+=k;
            x+=lowbit(x);
        }
    }

    int query(int x) {
        int res=0;
        while (x) {
            res+=c[x];
            x-=lowbit(x);
        }
        return res;
    }

}t;

void solve() {
    cin>>n>>m;
    for (int i=1;i<=n;i++) {
        cin>>s[i];
        t.update(i,s[i]-s[i-1]);
    }

    while (m--) {
        int opt,x,y,k;
        if (opt==1) {
            cin>>x>>y>>k;
            t.update(x,k);
            t.update(y+1,-k);
        }else {
            cin>>x;
            cout<<t.query(x)<<'\n';
        }
    }
}
```



### 区间修改，区间查询

> 其实这个是线段树的杂交版

www.luogu.com.cn/article/m0npccng



###### 版本1

```c++
constexpr int mxn=5e5+5;
int n,m,s[mxn];
struct BIT {
    int c[2][mxn];
    int lowbit(int x) {
        return x&-x;
    }

    void update(int x,int k) {
        for (int i=x;i<=n;i+=lowbit(i)) {
            c[0][i]+=k,c[1][i]+=k*x;
        }
    }

    int query(int x) {
        int res=0;
        for (int i=x;i>0;i-=lowbit(i)) {
            res+=c[0][i]*(x+1)-c[1][i];
        }
        return res;
    }

}t;

void solve() {
    cin>>n>>m;
    for (int i=1;i<=n;i++) {
        cin>>s[i];
        t.update(i,s[i]-s[i-1]);
    }

    while (m--) {
        int opt,x,y,k;
        cin>>opt;
        if (opt==1) {
            cin>>x>>y>>k;
            t.update(x,k);
            t.update(y+1,-k);
        }else {
            cin>>x>>y;
            cout<<t.query(y)-t.query(x-1)<<'\n';
        }
    }

}

```



###### 版本2

```c++
template<typename T>
struct bit {
    vector<T> a;
    explicit bit(u64 n) : a(n) {}

    void add(i64 x,T v) {
        for (i64 i=x;i<a.size();i+=(i&-i)) a[i]+=v; 
    }

    T query(i64 x) {
        auto ans=T();
        for (i64 i=x;i>0;i-=(i&-i)) ans+=a[i];
        return ans;
    }
    
};

void solve() {
    i64 n,m;
    cin>>n>>m;
    bit<i64> d(n+1),id(n+1);

    i64 z=0;
    for (i64 i=1;i<=n;i++) {
        i64 x;
        cin>>x;
        d.add(i,x-z);
        id.add(i,i*(x-z));
        z=x;
    }

    while (m--) {
        i64 c;
        cin>>c;
        i64 l,r,x;
        if (c==1) {
            cin>>l>>r>>x;
            d.add(l,x);
            d.add(r+1,-x);
            id.add(l,l*x);
            id.add(r+1,-(r+1)*x);
        }else {
            cin>>l>>r;
            i64 sumr=(r+1)*d.query(r)-id.query(r);
            i64 suml=(l*d.query(l-1))-id.query(l-1);
            cout<<sumr-suml<<'\n';
        }
    }
}
```



### 最值（不推荐）

太容易错了，不如直接线段树

```c++
int n,m;
vector<int> a;

struct bit {
    int c[mxn];
    int lowbit(int x) {
        return x&-x;
    }

    void build(int x) {
        for (int i=1;i<=x;i++) {
            c[i]=a[i];
            for (int j=1;j<lowbit(i);j<<=1) {
                c[i]=max(c[i],c[i-j]);
            }
        }

    }

    void update(int x,int k) {
        a[x]=k;
        while (x<=n) {
            c[x]=max(c[x],k);
            x+=lowbit(x);
        }
    }

    int query(int l,int r) {
        int res=-inf;
        while (r>=l) {
            if (r-lowbit(r)+1>=l) {
                res=max(res,c[r]);
                r-=lowbit(r);
            }else {
                res=max(res,a[r]);
                r--;
            }
        }
        return res;
    }

}t;
```







### 逆序对

> 树状数组维护cntx



> 在冒泡排序中一般用顺序， 因为冒泡排序每次未排好的max会沉底 ，
> 他想求的是i位置前，>a[i]的数的个数 ，此时的逆序对是受限的，然后max ，再+1， 即为ans
> 两种写法最后的逆序对之和会相等， 写法的选择 ，取决于对题目的分析 ，逆序对在那个区间取得
>
> 

> 求最小操作数使得顺序
> 冒泡排序 ，要保证每次交换都有效求逆序对数之和
> 因为我们当然选择逆序看i后面是否有逆序对，若有则都交换，这些被换到前面的数我们可以想象他们是流动的，小于下一个“判断站 ”（也就是原始a[i]啦），就滚到前面,
> 该操作数即为逆序对之和



###### 逆序写法

```c++
int n;
struct BIT {
    int c[mxn];

    int lowbit(int x) {
        return x&-x;
    }

    void update(int x,int k) {
        while (x<=n) {
            c[x]+=k;
            x+=lowbit(x);
        }
    }

    int query(int x) {
        int ans=0;
        while (x) {
            ans+=c[x];
            x-=lowbit(x);
        }
        return ans;
    }

}t;

void solve() {
    cin>>n;
    vector<int> a(n+1),b(n+1);
    for (int i=1;i<=n;i++) {
        cin>>a[i];
        b[i]=a[i];
    }

    //开始离散化
    i64 ans=0;
    sort(b.begin()+1,b.end());
    unique (b.begin()+1,b.end());
    for (int i=n;i>=1;i--) {//变索引，逆序
        a[i]=lower_bound(b.begin()+1,b.end(),a[i])-b.begin();//别再-1了，否则min的索引会变0
        ans+=t.query(a[i]-1);
        t.update(a[i],1);
    }

    cout<<ans<<'\n';
}

int main() {
    ios::sync_with_stdio(false);
    cin.tie(nullptr);

    int t=1;
    cin >> t;
    while(t--) {
        solve();
    }
    return 0;
}
```



###### 顺序写法

```c++
for (int i=1;i<=n;i++) {
        a[i]=lower_bound(rk.begin()+1,re.end(),a[i])-rk.begin();
        tree.update(a[i],1);//因为已插入i-1个数
    }
```



### 维护异或（区间修单点查）

https://www.luogu.com.cn/problem/P5057

* 也是0-->1 ,1-->0 ，然后查询某个元素的值

  



[P6225 [eJOI 2019\] 异或橙子 - 洛谷](https://www.luogu.com.cn/problem/P6225)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251215211634157.png" alt="image-20251215211634157" style="zoom:33%;" align="left"/>

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251215211703945.png" alt="image-20251215211703945" style="zoom:33%;" align="left"/>

> //其实建一个二维c也可以，个人喜欢啦
>
> //感觉这题主要是要想到位运算的处理技巧
> //对于区间[l,r],各点为a[i],我们只需找到a[i]出现在了多少个子区间里，奇数个则贡献^,偶数个则贡献0
> //由分步乘法可知（起点数*终点数），cnt=(i-l+1)*(r-i+1)，只需讨论两因子的奇偶性
> //都为奇才要运算，即l,r奇偶性同
> //其余均为0
>
> //下面是运算的实现，应考虑到i,当且仅当i,l,r三者奇偶同才^,也就是说我们要^的数据必然不连续，不妨设两个树状数组奇偶
> //每个数组维护的是该分块下，下标前的奇/偶数的^

```c++
int n,m,s[mxn];
struct BIT {
    int c[mxn];

    int lowbit(int x) {
        return x&(-x);
    }

    void update(int x,int k) {
        while (x<=n) {
            c[x]^=k;//这里异或
            x+=lowbit(x);
        }
    }

    int query(int x) {
        int ans=0;
        while (x) {
            ans^=c[x];//这里异或
            x-=lowbit(x);
        }
        return ans;
    }

}tree[2];

void solve() {
    cin>>n>>m;
    for (int i=1;i<=n;i++) {
        cin>>s[i];
        tree[i&1].update(i,s[i]);
    }

    while (m--) {
        int opt,x,y;
        cin>>opt>>x>>y;
        if (opt==1) {
            tree[x&1].update(x,s[x]^y);//这里异或
            s[x]=y;
        }else {
            if ((x&1)!=(y&1)) {
                cout<<0<<'\n';
            }else {
                cout<<((tree[x&1].query(y))^(tree[x&1].query(x-1)))<<'\n';//这里异或
            }
        }
    }

}
```



### 差分（其实也就一种思想）

[P2184 贪婪大陆 - 洛谷](https://www.luogu.com.cn/problem/P2184)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251216234332332.png" alt="image-20251216234332332" style="zoom:33%;" align="left"/>



差分：对于要查询的区间[l,r],  ans=r前面的start数（包括r)-l前面的end数（不包括l）

于是我们只需要用两个树状数组维护即可



## 权值树状数组

得先开离散化，权值树状数组下标为值，存储该元素出现的次数

[D-小月的前缀_牛客练习赛147](https://ac.nowcoder.com/acm/contest/125084/D)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251220122244729.png" alt="image-20251220122244729" style="zoom:50%;" />

```c++
void solve() {
    cin>>n;
    vector<i64> a(n+1);
    for (int i=1;i<=n;i++) {
        cin>>a[i];
        a.push_back(a[i]);
    }

    for (int i=1;i<=2*n;i++) {
        a[i]+=a[i-1];
    }

    auto b=a;
    sort(b.begin(),b.end());
    b.erase(unique(b.begin(),b.end()),b.end());
    for (int i=0;i<=2*n;i++) {
        a[i]=lower_bound(b.begin(),b.end(),a[i])-b.begin()+1;
    }

    for (int i=1;i<=n;i++) t.update(a[i],1);
    int res=0,ans=0,cnt=0;
    for (int i=1;i<=n;i++) {//窗口起点
        int res=n-t.query(a[i-1]);
        if (res>ans) {
            ans=res;
            cnt=i-1;
        }
        t.update(a[i],-1);
        t.update(a[i+n],1);
    }
    cout<<cnt<<" "<<ans<<'\n';

}
```



## 三元上升子序列

https://www.luogu.com.cn/problem/P1637

* 先离散化，再 O(n)计算每个元素左侧有多少个比自己小的，再重新用一次树状数组倒着遍历看右侧有多少个比自己大的，ans+=mn[i]*mx[i];





# 线段树

空间：O(4n)  时间:  O(lgn)

线段树的精髓在于他的懒标记的巧妙设计，以及区间操作



> 新手容易忘记调用build



## 基础线段树

### （仅）加法线段树

```c++
struct node {
    i64 l,r,val,add;//区间范围，懒标记
};

vector<i64> a;
vector<node> tr;

//上传
void pushup(i64 x) {
    tr[x].val=tr[x<<1].val+tr[x<<1|1].val;
}

//下传，处理懒标记
void pushdown(i64 x) {
    if (!tr[x].add) return;//无
    
    //传递懒标记
    tr[x<<1].add+=tr[x].add;
    tr[x<<1|1].add+=tr[x].add;
    
    //更新子节点的值
    tr[x<<1].val+=tr[x].add*(tr[x<<1].r-tr[x<<1].l+1);
    tr[x<<1|1].val+=tr[x].add*(tr[x<<1|1].r-tr[x<<1|1].l+1);
    
    tr[x].add=0;//清空当前节点的懒标记
}

//建树
void build(i64 x,i64 l,i64 r) {
    tr[x].l=l,tr[x].r=r,tr[x].add=0;//小心多测
    
    //叶子节点
    if (l==r) {
        tr[x].val=a[l];
        return;
    }

    //继续建左右子树
    i64 mid=(l+r)>>1;
    build(x<<1,l,mid);
    build(x<<1|1,mid+1,r);
    pushup(x);
}

void update(i64 x,i64 l,i64 r,i64 k) {//当前节点，待更新的区间范围，待更新值
    //当前节点区间完全包含再更新区间内
    if (tr[x].l>=l&&tr[x].r<=r) {
        tr[x].add+=k;
        tr[x].val+=k*(tr[x].r-tr[x].l+1);
        return;
    }

    //不在的话就得继续往下找，这时需要我们先下传懒标记
    pushdown(x);
    i64 mid=(tr[x].l+tr[x].r)>>1;
    if (mid>=l) update(x<<1,l,r,k);//与左子树有交集
    if (mid<r) update(x<<1|1,l,r,k);//与右子树有交集
    pushup(x);//最终要更新该点的值
}

//O(log n)
i64 query(i64 x,i64 l,i64 r) {//有点像update
    //包含
    if (tr[x].l>=l&&tr[x].r<=r) return tr[x].val;

    //不包含
    pushdown(x);
    i64 ans=0;
    i64 mid=(tr[x].l+tr[x].r)>>1;
    if (mid>=l) ans+=query(x<<1,l,r);
    if (mid<r) ans+=query(x<<1|1,l,r);
    return ans;
}

void solve() {
    i64 n,q;
    cin>>n>>q;

    a.resize(n+1);
    tr.resize(4*n+1);
    for (i64 i=1;i<=n;i++) cin>>a[i];
    build(1,1,n);

    while (q--) {
        i64 opt,l,r,k;
        cin>>opt;
        if (opt==1) {
            cin>>l>>r>>k;
            update(1,l,r,k);
        }else {
            cin>>l>>r;
            cout<<query(1,l,r)<<'\n';
        }
    }

}
```



### 加乘线段树

```c++
i64 n,m,mod;

struct tree {
    i64 l,r,sum,add,mul;
};

vector<tree> tr;
vector<i64> a;

void pushup(i64 x) {
    tr[x].sum=(tr[x<<1].sum+tr[x<<1|1].sum)%mod;
}

void pushdown(i64 x) {
    if (tr[x].mul==1&&!tr[x].add) return;

    tr[x<<1].mul=(tr[x<<1].mul*tr[x].mul)%mod;
    tr[x<<1|1].mul=(tr[x<<1|1].mul*tr[x].mul)%mod;

    tr[x<<1].add=(tr[x<<1].add*tr[x].mul+tr[x].add)%mod;
    tr[x<<1|1].add=(tr[x<<1|1].add*tr[x].mul+tr[x].add)%mod;

    tr[x<<1].sum=(tr[x<<1].sum*tr[x].mul+tr[x].add*(tr[x<<1].r-tr[x<<1].l+1))%mod;
    tr[x<<1|1].sum=(tr[x<<1|1].sum*tr[x].mul+tr[x].add*(tr[x<<1|1].r-tr[x<<1|1].l+1))%mod;

    tr[x].mul=1;
    tr[x].add=0;

}

void build(i64 x,i64 l,i64 r) {
    tr[x].l=l,tr[x].r=r,tr[x].mul=1,tr[x].add=0;

    if (l==r) {
        tr[x].sum=a[l]%mod;
        return;
    }

    i64 mid=(l+r)>>1;
    build(x<<1,l,mid);
    build(x<<1|1,mid+1,r);
    pushup(x);

}

void update(i64 x,i64 l,i64 r,i64 k,i64 p) {//加，乘
    if (l<=tr[x].l&&r>=tr[x].r) {
        tr[x].add=(tr[x].add*p+k)%mod;
        tr[x].mul=(tr[x].mul*p)%mod;
        tr[x].sum=(tr[x].sum*p+k*(tr[x].r-tr[x].l+1))%mod;
        return;
    }

    pushdown(x);
    i64 mid=(tr[x].l+tr[x].r)>>1;
    if (l<=mid) update(x<<1,l,r,k,p);
    if (r>mid) update(x<<1|1,l,r,k,p);
    pushup(x);

}

i64 query(i64 x,i64 l,i64 r) {
    if (l<=tr[x].l&&r>=tr[x].r) {
        return tr[x].sum;
    }

    pushdown(x);
    i64 mid=(tr[x].l+tr[x].r)>>1;
    i64 ans=0;
    if (l<=mid) ans=(ans+query(x<<1,l,r))%mod;
    if (r>mid) ans=(ans+query(x<<1|1,l,r))%mod;
    return ans;
}

void solve() {
    cin>>n>>m>>mod;
    a.resize(n+1);
    tr.resize(4*n+1);

    for (i64 i=1;i<=n;i++) {
        cin>>a[i];
    }

    build(1,1,n);

    while (m--) {
        i64 opt,l,r,k;
        cin>>opt>>l>>r;
        if (opt==1) {//乘
            cin>>k;
            update(1,l,r,0,k);
        }else if (opt==2) {//加
            cin>>k;
            update(1,l,r,k,1);
        }else {//查询
            cout<<query(1,l,r)<<'\n';
        }
    }
}
```



分着写

```c++
void chmul(i64 x,i64 l,i64 r,i64 k) {
    if (l<=tr[x].l&&r>=tr[x].r) {
        tr[x].add=(tr[x].add*k)%mod;
        tr[x].mul=(tr[x].mul*k)%mod;
        tr[x].sum=(tr[x].sum*k)%mod;
        return;
    }

    pushdown(x);
    i64 mid=(tr[x].l+tr[x].r)>>1;
    if (l<=mid) chmul(x<<1,l,r,k);
    if (r>mid) chmul(x<<1|1,l,r,k);
    pushup(x);

}

void chadd(i64 x,i64 l,i64 r,i64 k) {
    if (l<=tr[x].l&&r>=tr[x].r) {
        tr[x].add=(tr[x].add+k)%mod;
        tr[x].sum=(tr[x].sum+k*(tr[x].r-tr[x].l+1))%mod;
        return;
    }

    pushdown(x);
    i64 mid=(tr[x].l+tr[x].r)>>1;
    if (l<=mid) chadd(x<<1,l,r,k);
    if (r>mid) chadd(x<<1|1,l,r,k);
    pushup(x);
}
```



### 赋值线段树

区间赋值： 把[l,r] 全赋值为x

区间和查询



[E-小苯的数组操作_牛客周赛 Round 125](https://ac.nowcoder.com/acm/contest/126319/E)

```c++
struct tree {
    i64 l,r,min,sum,add;
};

vector<i64> a;
vector<tree> tr;

void pushup(i64 x) {
    tr[x].sum=tr[x<<1].sum+tr[x<<1|1].sum;
    tr[x].min=min(tr[x<<1].min,tr[x<<1|1].min);
}

void pushdown(i64 x) {
    if (!tr[x].add) return;
    tr[x<<1].add=tr[x].add;//把+改为=
    tr[x<<1|1].add=tr[x].add;//=

    tr[x<<1].min=tr[x].add;//=
    tr[x<<1|1].min=tr[x].add;//=

    tr[x<<1].sum=tr[x].add*(tr[x<<1].r-tr[x<<1].l+1);//=
    tr[x<<1|1].sum=tr[x].add*(tr[x<<1|1].r-tr[x<<1|1].l+1);//=
    tr[x].add=0;
}

void build(i64 x,i64 l,i64 r) {
    tr[x].l=l,tr[x].r=r,tr[x].add=0;
    if (l==r) {
        tr[x].min=a[l];
        tr[x].sum=a[l];
        return;
    }

    i64 mid=(l+r)>>1;
    build(x<<1,l,mid);
    build(x<<1|1,mid+1,r);
    pushup(x);

}

void update(i64 x,i64 l,i64 r,i64 k) {
    if (l<=tr[x].l&&r>=tr[x].r) {
        tr[x].add=k;
        tr[x].min=k;
        tr[x].sum=k*(tr[x].r-tr[x].l+1);
        return;
    }

    pushdown(x);
    i64 mid=(tr[x].l+tr[x].r)>>1;
    if (l<=mid) update(x<<1,l,r,k);
    if (r>mid) update(x<<1|1,l,r,k);
    pushup(x);

}

i64 querysum(i64 x,i64 l,i64 r) {
    if (l<=tr[x].l&&r>=tr[x].r) return tr[x].sum;
    pushdown(x);
    i64 mid=(tr[x].l+tr[x].r)>>1;
    i64 ans=0;
    if (l<=mid) ans+=querysum(x<<1,l,r);
    if (r>mid) ans+=querysum(x<<1|1,l,r);
    return ans;
}

i64 querymin(i64 x,i64 l,i64 r) {
    if (l<=tr[x].l&&r>=tr[x].r) return tr[x].min;
    pushdown(x);
    i64 mid=(tr[x].l+tr[x].r)>>1;
    i64 ans=inf;
    if (l<=mid) ans=querymin(x<<1,l,r);
    if (r>mid) ans=min(ans,querymin(x<<1|1,l,r));//!!!先赋值，再取min
    return ans;
}
```



### 区间异或线段树（区间修区间查）

[P2574 XOR的艺术 - 洛谷](https://www.luogu.com.cn/problem/P2574)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251215225618762.png" alt="image-20251215225618762" style="zoom:33%;" align="left"/>



巧妙设计懒标记，改改懒标记的下传和值的更新就好

```c++
void pushdown(i64 x) {
    if (!tr[x].add) return;
    tr[x<<1].add^=1;
    tr[x<<1|1].add^=1;
    tr[x<<1].val=tr[x<<1].r-tr[x<<1].l+1-tr[x<<1].val;
    tr[x<<1|1].val=tr[x<<1|1].r-tr[x<<1|1].l+1-tr[x<<1|1].val;
    tr[x].add=0;
}

void update(i64 x,i64 l,i64 r) {
    if (tr[x].l>=l&&tr[x].r<=r) {
        tr[x].add^=1;
        tr[x].val=tr[x].r-tr[x].l+1-tr[x].val;
        return;
    }

    pushdown(x);
    i64 mid=(tr[x].l+tr[x].r)>>1;
    if (mid>=l) update(x<<1,l,r);
    if (mid<r) update(x<<1|1,l,r);
    pushup(x);
}
```



### （仅）最值线段树

> 不用开懒标记，这里也没开struct ,因此第一次调用时，l,r是1,n

```c++
vector<int> a,tr;

void pushup(int rt) {
    tr[rt]=max(tr[rt<<1],tr[rt<<1|1]);
}

void build(int rt,int l,int r) {
    if (l==r) {
        tr[rt]=a[l];
        return;
    }

    int mid=(l+r)>>1;
    build(rt<<1,l,mid);
    build(rt<<1|1,mid+1,r);
    pushup(rt);
}

void update(int rt,int l,int r,int x,int y) {//l,r刚开始是1,n; x是点，y是值
    if (l==r) {
        if (tr[rt]<y) tr[rt]=y;//依题意修改
        return;
    }

    int mid=(l+r)>>1;
    if (x<=mid) update(rt<<1,l,mid,x,y);
    else update(rt<<1|1,mid+1,r,x,y);
    pushup(rt);
}

int query(int rt,int l,int r,int x,int y) {//区间x,y
    if (x<=l&&r<=y) return tr[rt];
    int mid=(l+r)>>1;
    int ans=-inf;
    if (x<=mid) ans=max(ans,query(rt<<1,l,mid,x,y));
    if (y>mid) ans=max(ans,query(rt<<1|1,mid+1,r,x,y));
    return ans;
}

void solve() {
    int n,m;
    cin>>n>>m;
    a.resize(n+1);
    tr.resize(4*n+1);
    for (int i=1;i<=n;i++) {
        cin>>a[i];
    }

    build(1,1,n);
    while (m--) {
        char ch;
        int x,y;
        cin>>ch>>x>>y;
        if (ch=='Q') cout<<query(1,1,n,x,y)<<'\n';
        else update(1,1,n,x,y);
    }

}
```



### 加法+最值线段树

* 区间加法
* 查询：区间min,max,sum



```c++
i64 n,m;
struct tree {
    i64 l,r,min,sum,add;
};

vector<i64> a;
vector<tree> tr;

void pushup(i64 x) {
    tr[x].sum=tr[x<<1].sum+tr[x<<1|1].sum;
    tr[x].min=min(tr[x<<1].min,tr[x<<1|1].min);
}

void pushdown(i64 x) {
    if (!tr[x].add) return;
    tr[x<<1].add+=tr[x].add;
    tr[x<<1|1].add+=tr[x].add;
    tr[x<<1].min+=tr[x].add;
    tr[x<<1|1].min+=tr[x].add;
    tr[x<<1].sum+=tr[x].add*(tr[x<<1].r-tr[x<<1].l+1);
    tr[x<<1|1].sum+=tr[x].add*(tr[x<<1|1].r-tr[x<<1|1].l+1);
    tr[x].add=0;
}

void build(i64 x,i64 l,i64 r) {
    tr[x].l=l,tr[x].r=r，tr[x].add=0;
    if (l==r) {
        tr[x].min=a[l];
        tr[x].sum=a[l];
        return;
    }

    i64 mid=(l+r)>>1;
    build(x<<1,l,mid);
    build(x<<1|1,mid+1,r);
    pushup(x);

}

void update(i64 x,i64 l,i64 r,i64 k) {
    if (l<=tr[x].l&&r>=tr[x].r) {
        tr[x].add+=k;
        tr[x].min+=k;
        tr[x].sum+=k*(tr[x].r-tr[x].l+1);
        return;
    }

    pushdown(x);
    i64 mid=(tr[x].l+tr[x].r)>>1;
    if (l<=mid) update(x<<1,l,r,k);
    if (r>mid) update(x<<1|1,l,r,k);
    pushup(x);

}

i64 querysum(i64 x,i64 l,i64 r) {
    if (l<=tr[x].l&&r>=tr[x].r) return tr[x].sum;
    pushdown(x);
    i64 mid=(tr[x].l+tr[x].r)>>1;
    i64 ans=0;
    if (l<=mid) ans+=querysum(x<<1,l,r);
    if (r>mid) ans+=querysum(x<<1|1,l,r);
    return ans;
}

i64 querymin(i64 x,i64 l,i64 r) {
    if (l<=tr[x].l&&r>=tr[x].r) return tr[x].min;
    pushdown(x);
    i64 mid=(tr[x].l+tr[x].r)>>1;
    i64 ans=inf;
    if (l<=mid) ans=querymin(x<<1,l,r);
    if (r>mid) ans=min(ans,querymin(x<<1|1,l,r));//!!!先赋值，再取min 
    return ans;
}
```



### 例题

#### 维护差分

[P1438 无聊的数列 - 洛谷](https://www.luogu.com.cn/problem/P1438)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251217104228417.png" alt="image-20251217104228417" style="zoom:33%;" align="left"/>

build的时候build差分数组

`a.resize(n+2),b.resize(n+2),tr.resize(4*n+5);`

`build(1,1,n+1);`



## 进阶操作

### 线段树上二分

本质思想：依照参考点二分查找，左子树or右子树

法1：

时间复杂度：O(log n)

```c++
//在solve里记得要用(1,1,n,x)，在整个区间内查找，二分会自己限制范围，如果不在整个区间里找会出错（边界卡掉了啥的）
i64 find_left(i64 x,i64 l,i64 r,i64 pos) {//在那个子树找，范围，参照点
    if (l>pos) return 0;//越界
    if (tr[x].val==r-l+1) return 0;//大区间已经不可能了，再分块已无意义
    if (l==r) return l;

    pushdown(x);
    i64 mid=(l+r)>>1,res=0;
    if (mid<=pos) res=find_left(x<<1|1,mid+1,r,pos);//说明pos在右子树，我们就先从右子树找
    if (!res) res=find_left(x<<1,l,mid,pos);//不在或找不到
    return res;

}

i64 find_right(i64 x,i64 l,i64 r,i64 pos) {
    if (r<pos) return tr[1].r+1;
    if (tr[x].val==r-l+1) return tr[1].r+1;
    if (l==r) return l;

    pushdown(x);
    i64 mid=(l+r)>>1,res=tr[1].r+1;
    if (mid>=pos) res=find_right(x<<1,l,mid,pos);
    if (res==tr[1].r+1) res=find_right(x<<1|1,mid+1,r,pos);
    return res;
}
```



法2：

找pos左边的第一个x,单独套二分函数，

时间复杂度 O(log n * log n)

```c++
i64  find_left(i64 x,i64 pos){
    if (pos<1) return 0;

    i64 l=1,r=pos,res=pos;
    while (l<=r) {
        i64 mid=(l+r)>>1;
        i64 sum=query(1,mid,pos);
        if (sum<pos-mid+1) {
            res=mid;
            l=mid+1;
        }else r=mid-1;
    }
    return res;
}
```







# 二叉树

## 普通二叉树

* 查元素排名
* 查第k个元素
* 查小于/大于 元素x的第一个元素（前驱/后继）
* 插入元素



https://www.luogu.com.cn/problem/P5076

```c++
    multiset<int> q;
    q.insert(-inf),q.insert(inf);

    while (n--) {
        int opt,x;
        cin>>opt>>x;

        if (opt==1) {//查x的排名
            auto it =q.lower_bound(x);

            int order=0;
            auto pos=q.begin();
            while (pos!=it) {
                pos++;
                order++;
            }
            cout<<order<<'\n';
        }else if (opt==2) {//查第x个
            int order=-1;
            for (auto i:q) {
                if (++order==x) {
                    cout<<i<<'\n';
                }
            }
        }else if (opt==3) {//前驱
            auto it =q.lower_bound(x);
            cout<<*(--it)<<'\n';
        }else if (opt==4) {//后驱
            auto it =q.upper_bound(x);
            cout<<*it<<'\n';
        }else {
            q.insert(x);
        }

    }
```



## 完全二叉树

### 前缀异或和维护

* 注意这里的前缀是二叉前缀，不是我们数组的那种，画图会更好理解
* 这里解决x在树中的异或前缀和的排名
* 时间复杂度：O(n) ,n<=20时用

[Problem - F - Codeforces](https://codeforces.com/contest/2185/problem/F)

```c++
    //建树
    vector<int> a((1ll<<(n+1))+1);
    for (int i=(1ll<<n);i<=(1ll<<(n+1))-1;i++) {
        cin>>a[i];
    }

    //计算二叉树上各点的前缀和
    for (int i=(1ll<<n)-1;i>=1;i--) {
        a[i]=a[i*2]^a[i*2+1];
    }

    while (q--) {
        int p,x;
        cin>>p>>x;//位置，改值
        p+=(1ll<<n)-1;//改为二叉序号

        int cur=0,h=0;
        while (p>1) {
            //与兄弟节点比较
            if (x<a[p^1]||(x==a[p^1]&&p%2==1)) cur+=(1ll<<h);
            
            h++;//层数
            x^=a[p^1];
            p/=2;//p^1为兄弟节点
        }
        cout<<cur<<'\n';
    }
```





## 二叉搜索树

### 笛卡尔树

* 对于区间  [l,r]  ，在笛卡尔树中把该区间找出来，lca 就是ans

[P5854 【模板】笛卡尔树 - 洛谷](https://www.luogu.com.cn/problem/P5854)

[笛卡尔树 - OI Wiki](https://oi-wiki.org/ds/cartesian-tree/)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20260124163437538.png" alt="image-20260124163437538" style="zoom:45%;" />







<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20260124163519336.png" alt="image-20260124163519336" style="zoom:45%;" />



* 从根一直走右子树，就是单调栈（递增栈），所谓的左儿子的形成其实就是插入后的影响



```c++
    int pos=0,top=0;
    for (int i=1;i<=n;i++) {
        cin>>a[i];

        pos=top;
        while (pos&&a[st[pos]]>a[i]) pos--;
        if (pos) rs[st[pos]]=i;//找到<= 自己的
        if (pos<top) ls[i]=st[pos+1];//把自己插入后，st中自己后面的那些,接入不需
        st[++pos]=i;
        top=pos;
    }
```



# 字典树

Trie,也称前缀树

用于存储和查询字符串，利用字符串的公共前缀来节约空间



## 前缀Trie

* 需要根据题目的要求，深刻理解板子的执行过程，然后进行功能上的微改



* 这个(dfs)是自下而上的更新，是整体的结果，是这条路（也就是这个s1)，有多少个string 是以s1为前缀的

```c++
//(记得 solve 那里 Trie t)
int get(char ch) {
    int c;
    if (ch>='a'&&ch<='z') c=ch-'a';
    else if (ch>='A'&&ch<='Z') c=ch-'A'+26;
    else c=ch-'0'+52;
    return c;
}
struct Trie {
    struct node {
        array<int,62> nx;//下标是每个结点的可选路径，值是下次的起点
        int cnt;//记录公共前缀和
    };
    
    vector<node> trie;
    Trie(): trie(1){};//构造函数
    
    void insert(const string &s) {
        int p=0;
        for (char c: s) {
            int i=get(c);
            if (!trie[p].nx[i]) {
                trie[p].nx[i]=trie.size();
                trie.emplace_back();//动态扩增
            }
            p=trie[p].nx[i];//更新起点
        }
        trie[p].cnt++;//更新公共前缀数
    }
    
    int dfs(int x) {
        for (int i:trie[x].nx) {//遍历该节点的路
            if (!i) continue;//无效路径(62 条)
            dfs(i);
            trie[x].cnt+=trie[i].cnt;
        }
        return trie[x].cnt;//自下而上的更新
    }
    
    int find(const string &s) {
        int p=0;
        for (char c: s) {
            int i=get(c);
            if (!trie[p].nx[i]) return 0;
            p=trie[p].nx[i];
        }
        return trie[p].cnt;
    }
};
```



* (dfs) 自上而下的更新，这条路上(s1) 有多少个string ,（可以理解成这些string都是s1的前缀）
* 就是不考虑在他后面的那些（即使有共同前缀）,可以帮助我们找第k个string

```c++
    void dfs(int x) {
        for (int i=0;i<2;i++) {
            int y=trie[x].nx[i];
            if (y) {
                trie[y].cnt+=trie[x].cnt;
                dfs(y);
            }
        }
    }
```



* 输出这个string

```c++
    bool find(int x) {
        if (trie[x].cnt==k) {
            cout<<cur;
            return true;
        }

        for (int i=0;i<2;i++) {
            int y=trie[x].nx[i];
            if (y) {
                cur+=i+'0';
                if (find(y)) return true;
                cur.pop_back();
            }
        }
        return false;
    }
```



[G-小红的字符串构造（hard）_牛客周赛 Round 126](https://ac.nowcoder.com/acm/contest/126636/G)







## 边权Trie（模拟构建，顺序输出）

* 加深对字典树的理解

[E - Sort Arrays](https://atcoder.jp/contests/abc437/tasks/abc437_e)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251222144424985.png" alt="image-20251222144424985" style="zoom:50%;" />



```c++
struct node {
    vector<int> ids;
    map<int,int> nx;//键是边权，值是下一个节点的位置
};

vector<node> trie;
vector<int> pos;

void dfs(int x) {
    for (int i:trie[x].ids) {//字典序相同的
        cout<<i<<" ";
    }
    for (auto [w,i]:trie[x].nx) {
        dfs(i);
    }
}

void solve() {
    int n;
    cin>>n;

    //构建字典树
    pos.resize(n+1);
    trie.resize(1);
    for (int i=1;i<=n;i++) {
        int x,y;
        cin>>x>>y;

        int u=pos[x];
        if (trie[u].nx.find(y)==trie[u].nx.end()) {
            trie[u].nx[y]=trie.size();
            trie.push_back(node());
        }

        int v=trie[u].nx[y];
        pos[i]=v;
        trie[v].ids.push_back(i);//相同的

    }

    dfs(0);
}
```



封装版

```c++
vector<int> pos;
struct Trie {
    struct node {
        map<i64,i64> nx;
        vector<i64> ids;
    };

    vector<node> trie;
    Trie(): trie(1){};

    void insert(i64 x,i64 y,i64 i) {
        if (!trie[x].nx[y]) {
            trie[x].nx[y]=trie.size();
            trie.emplace_back();
        }
        int t=trie[x].nx[y];
        pos[i]=t;
        trie[t].ids.push_back(i);
    }

    void dfs(i64 x) {
        for (auto i:trie[x].ids) {
            cout<<i<<" ";
        }
        for (auto [u,v]:trie[x].nx) {
            dfs(v);
        }
    }

};

void solve() {
    Trie t;
    int n;
    cin>>n;
    pos.resize(n+1);
    for (int i=1;i<=n;i++) {
        i64 x,y;
        cin>>x>>y;
        t.insert(pos[x],y,i);
    }

    t.dfs(0);
}
```



## 01Trie

### 最大异或对

[P10471 最大异或对 The XOR Largest Pair - 洛谷](https://www.luogu.com.cn/problem/P10471)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251222171818790.png" alt="image-20251222171818790" style="zoom: 33%;" align="left"/>



* 越接近根部的那个位就越高
* 考虑贪心，从高位开始贪，尽量找与自己不同的，然后O(n)遍历即可

```c++
struct Trie {
    struct node {
        array<i64,2> nx;
    };

    vector<node> trie;
    Trie(): trie(1){};

    void insert(i64 x) {
        int p=0;
        for (int i=31;i>=0;i--) {
            int y=(x>>i)&1;
            if (!trie[p].nx[y]) {
                trie[p].nx[y]=trie.size();
                trie.emplace_back();
            }
            p=trie[p].nx[y];
        }
    }

    i64 find(i64 x) {
        i64 ans=0;
        int p=0;
        for (int i=31;i>=0;i--) {
            int y=(x>>i)&1;
            if (trie[p].nx[y^1]) {
                ans+=(1<<i);
                p=trie[p].nx[y^1];
            }else {
                p=trie[p].nx[y];
            }
        }
        return ans;
    }

};
```



### 最长异或路径

[P4551 最长异或路径 - 洛谷](https://www.luogu.com.cn/problem/P4551)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251222202449750.png" alt="image-20251222202449750" style="zoom:33%;" align="left"/>

* 首先搞明白两个节点的异或值=他们各自到根节点的异或值再异或，这个dis[i]我们用dfs跑即可
* 然后处理最大值问题，把dis[i]插入trie即可转化为最大异或对问题



```c++
vector<vector<pair<int,int>>> adj;
vector<i64> dis,fa;

struct Trie {
    struct node {
        array<int,2> nx;
    };

    vector<node> trie;
    Trie(): trie(1){};

    void insert(i64 x) {
        int p=0;
        for (int i=31;i>=0;i--) {
            int y=(x>>i)&1;
            if (!trie[p].nx[y]) {
                trie[p].nx[y]=trie.size();
                trie.emplace_back();
            }
            p=trie[p].nx[y];
        }
    }

    i64 find(i64 x) {
        i64 ans=0;
        int p=0;
        for (int i=31;i>=0;i--) {
            int y=(x>>i)&1;
            if (trie[p].nx[y^1]) {
                ans+=(1<<i);
                p=trie[p].nx[y^1];
            }else {
                p=trie[p].nx[y];
            }
        }
        return ans;
    }
};

void dfs(i64 x) {
    i64 ans=0;
    for (auto [u,v]: adj[x]) {
        if (u==fa[x]) continue;
        fa[u]=x;
        dis[u]=dis[x]^v;
        dfs(u);
    }

}

void solve() {
    Trie t;
    int n;
    cin>>n;
    adj.resize(n+1);
    dis.resize(n+1);
    fa.resize(n+1);
    for (int i=1;i<n;i++) {
        i64 u,v,w;
        cin>>u>>v>>w;
        adj[u].emplace_back(v,w);
        adj[v].emplace_back(u,w);
    }

    dfs(1);
    for (int i=1;i<=n;i++) {
        t.insert(dis[i]);
    }

    i64 ans=0;
    for (int i=1;i<=n;i++) {
        i64 res=t.find(dis[i]);
        ans=max(ans,res);
    }
    cout<<ans<<'\n';
}
```







# 堆



### 基本语法

(1)

```c++
大根堆： priority_queue<int,vector<int>>;//先弹出大的
小根堆： prioriry_queue<int,vector<int>,great<int>>;

		pq.size();
		pq.empty();
		pq.push(k);
		pq.pop();
		pq.top();
```

(2) 优先比较级函数

* 这个写法就算不用堆也能应用，<<升序，<>降序
* 无论如何都要记得在solve那里加上sort(a.begin(),a.end());

```c++
struct node  {
    int val,rnd;
    bool operator <  (const node &x) const  { //这行的符号两个堆一样，且必须用这个
        return rnd<x.rnd;//会自动调用, 大根堆用 <  小根堆用 > ,无需调用sort
    }  
}a [100];
```



(3) tuple

```c++
最大堆优先队列 ：默认以第一个元素降序排 priority_queue<tuple<int,int,int,int>> pq;
查询 ：auto[d,p,l,r] = pq.top();
删除： pq.pop()；
```



(4) 自定义排序

```c++
// 优先队列存储 (值, 索引)，按值排序，值相同的按索引小的优先
auto cmp = [](const pair<int, int>& a, const pair<int, int>& b) {
    if (a.first == b.first) {
        return a.second > b.second;  // 索引小的优先
    }
    return a.first < b.first;  // 值大的优先
};
priority_queue<pair<int, int>, vector<pair<int, int>>, decltype(cmp)> pq(cmp);
```





# map



map<int,int> 随插随用，不用像数组那样开那么大



# 单调队列

> 一般用来解决滑动窗口问题，而滑动窗口一般可以用于dp优化



* mx递减栈， mn 递增栈



## 一维

[P1886 【模板】单调队列 / 滑动窗口 - 洛谷](https://www.luogu.com.cn/problem/P1886)

```c++
void solve() {
    int n,k;
    cin>>n>>k;

    pair<int,int> p;//tp,id

    deque<pair<int,int>> mx,mn;
    vector<int> a(n-k+2),b(n-k+2);

    for (int i=1;i<=n;i++) {
        int x;
        cin>>x;

        p.first=x,p.second=i;

        while (!mx.empty()&&mx.back().first<=x) mx.pop_back();
        while (!mn.empty()&&mn.back().first>=x) mn.pop_back();

        mx.push_back(p),mn.push_back(p);

        while (!mx.empty()&&mx.front().second<=i-k) mx.pop_front();
        while (!mn.empty()&&mn.front().second<=i-k) mn.pop_front();

        if (i>=k) {
            a[i-k+1]=mn.front().first;
            b[i-k+1]=mx.front().first;
        }
    }
}
```



## 二维

[P2216 [HAOI2007\] 理想的正方形 - 洛谷](https://www.luogu.com.cn/problem/P2216)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251209222659403.png" alt="image-20251209222659403" style="zoom:33%;" align="left"/>

```c++
struct node {
    i64 id,tp;
}p;

void solve() {
    int n,m,k;
    cin>>n>>m>>k;

    vector<vector<i64>> a(n+1,vector<i64>(m+1));
    for (int i=1;i<=n;i++) {
        for (int j=1;j<=m;j++) {
            cin>>a[i][j];
        }
    }

    vector<vector<i64>> hax(n+1,vector<i64>(m+1)),han(n+1,vector<i64>(m+1));
    for (int i=1;i<=n;i++) {
        deque<node> qx,qn;//记得要放在里面更新，因为每行都得重新记录数据
        for (int j=1;j<=m;j++) {
            p.id=j,p.tp=a[i][j];

            while (!qx.empty()&&qx.back().tp<=p.tp)  qx.pop_back();
            qx.push_back(p);
            while (!qx.empty()&&qx.front().id<=p.id-k) qx.pop_front();

            while (!qn.empty()&&qn.back().tp>=p.tp) qn.pop_back();
            qn.push_back(p);
            while (!qn.empty()&&qn.front().id<=p.id-k) qn.pop_front();

            if (j>=k) {
                hax[i][j]=qx.front().tp;
                han[i][j]=qn.front().tp;
            }
        }
    }
    vector<vector<i64>> mp(n+1,vector<i64>(m+1));//记录每个矩阵的差值，以x,y为右下角的矩阵
    for (int i=1;i<=m;i++) {//列
        deque<node> qxx,qnn;
        for (int j=1;j<=n;j++) {//行
            while (!qxx.empty()&&qxx.back().tp<=hax[j][i]) qxx.pop_back();
            qxx.push_back({j,hax[j][i]});
            while (!qxx.empty()&&qxx.front().id<=j-k) qxx.pop_front();

            while (!qnn.empty()&&qnn.back().tp>=han[j][i]) qnn.pop_back();
            qnn.push_back({j,han[j][i]});
            while (!qnn.empty()&&qnn.front().id<=j-k) qnn.pop_front();

            if (i>=k&&j>=k) {
                mp[j][i]=qxx.front().tp-qnn.front().tp;
            }
        }
    }

    i64 ans=inf;
    for (int i=k;i<=n;i++) {
        for (int j=k;j<=m;j++) {
            ans=min(ans,mp[i][j]);
        }
    }
```



# 单调栈

> 本质：维护所有前缀的后缀最值

> 单调性，区间长度不定：单调栈，单调队列

* 可以用双端队列deque代替，还能一键清空  dq.clear()

* 栈内一般存元素下标idx



查找第一个比自己大的元素

这里更重要的是他的实现的思想，而不是栈

[P5788 【模板】单调栈 - 洛谷](https://www.luogu.com.cn/problem/P5788)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251217155936844.png" alt="image-20251217155936844" style="zoom: 33%;" align="left"/>



> 正向：st存的是左边未找到ans的元素的下标，这个必然是单调递减的，否则说明你没有更新给某个元素的ans！！！

递减栈

```c++
    stack<int> st;
    vector<int> ans(n+1);
    for (int i=1;i<=n;i++) {
        while (!st.empty()&&a[st.top()]<a[i]) {
            ans[st.top()]=i;
            st.pop();
        }

        st.push(i);//自己也入栈
    }
```



> 反向:st存右边已遍历找到ans的元素,还是向栈顶的单调递减栈

```c++
    stack<int> st;
    for (int i=n;i>=1;i--) {
        while (!st.empty()&&a[st.top()]<=a[i]) st.pop();

        if (!st.empty()&&a[st.top()]>a[i]) {
            ans[i]=st.top();
        }

        st.push(i);
    }
```





[B3666 求数列所有后缀最大值的位置 - 洛谷](https://www.luogu.com.cn/problem/B3666)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251217170605777.png" alt="image-20251217170605777" style="zoom:33%;" align="left"/>

> 用单调栈维护pos（所有的后缀最大值的位置即可）





[P6510 奶牛排队 - 洛谷](https://www.luogu.com.cn/problem/P6510)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251218194626406.png" alt="image-20251218194626406" style="zoom:33%;" align="left"/>

对于一个以B结尾的区间，A必定是后缀最小值，B必定是后缀最大值，

看到这种后缀最值的题，我们不妨用2个单调栈来维护，容易发现，A是在从B往左数的第二个后缀最大值的右侧，因此我们还需借助upper_bound的实现，只能模拟栈了



```c++
    int tx=0,tn=0,ans=0;
    for (int i=1;i<=n;i++) {
        while (tx&&a[sx[tx]]<=a[i]) tx--;
        while (tn&&a[sn[tn]]>=a[i]) tn--;

        int k=upper_bound(sn.begin()+1,sn.begin()+tn,sx[tx])-sn.begin();
        if (k!=tn+1) ans=max(ans,i-sn[k]+1);

        sn[++tn]=i;
        sx[++tx]=i;
    }
```





[P6503 [COCI 2010/2011 #3\] DIFERENCIJA - 洛谷](https://www.luogu.com.cn/problem/P6503)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251218211717745.png" alt="image-20251218211717745" style="zoom:33%;" align="left"/>



单调性，区间长度不定，直接试试单调栈吧

你想，你从后往前比，有资格和当前的数比较的数肯定是越来越大的，可以联想到单调栈

* 首先对于区间的题我们可以用状态转移，我们改装一下公式，就是变成了每个子序列的max-min;
* 这里 f[i] / g[i] 表示以i结尾的子序列的max/min之和，O(n)遍历右端点
* 怎么转移：这里讲f,  g 同理， 其实每新增一个数，首先他一定会在仅含自己的区间作用，接着由于区间元素是连续的，所以我们只需将a[i]与它前面的max数(到这里我们应该就可以知道是所谓的后缀最值了)比较，直到找到比它大的最近的数，者之间的范围就是a[i]的作用区间 a[i]*(i-p+1);  
* 然后记得入栈

```c++
    stack<i64> sn,sx;
    vector<i64> f(n+1),g(n+1);
    i64 ans=0;
    for (int i=1;i<=n;i++) {
        while (!sx.empty()&&a[sx.top()]<=a[i]) sx.pop();
        while (!sn.empty()&&a[sn.top()]>=a[i]) sn.pop();

        if (!sx.empty()) f[i]=f[sx.top()]+a[i]*(i-sx.top());
        else f[i]=a[i]*i;

        if (!sn.empty()) g[i]=g[sn.top()]+a[i]*(i-sn.top());
        else g[i]=a[i]*i;

        sn.push(i);
        sx.push(i);

        ans+=f[i]-g[i];
    }
```



[P1823 [COI 2007\] Patrik 音乐会的等待 - 洛谷](https://www.luogu.com.cn/problem/P1823)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251219171556446.png" alt="image-20251219171556446" style="zoom:33%;" align="left"/>

这里建议甄别出这种情况  4 2 3 2 5  ，这里1号位不能看到4号位

* 向后看的话不好维护，向前看
* **向前看查询第一个比自己高的人x**，如果两者之间其实还有元素，那x必定不是当前栈顶，可以想到者之间的元素如果现在不在栈内，那必然是被挡住了，用不了



```c++
void solve() {
    int n;
    cin>>n;
    vector<i64> a(n+1);
    for (int i=1;i<=n;i++) {
        cin>>a[i];
    }

    stack<pair<i64,i64>> st;//id,与自己同身高的人数
    i64 ans=0;
    for (int i=1;i<=n;i++) {
        pair<i64,i64> p={i,1};
        while (!st.empty()&&a[st.top().first]<=a[i]) {
            ans+=st.top().second;
            if (a[st.top().first]==a[i]) p.second+=st.top().second;
            st.pop();
        }

        if (!st.empty()) ans++;
        st.push(p);
    }
    cout<<ans<<'\n';

}
```



[P2659 美丽的序列 - 洛谷](https://www.luogu.com.cn/problem/P2659)

* 找到该元素左边和右边比它小的第一个位置



[B - Minimum Sum](https://atcoder.jp/contests/agc005/tasks/agc005_b)

* 贡献法，考虑每个数贡献给多少个区间

* 与上题同



# 线性基

线性基就是由原数列集合构造出的满足下面性质的集合：

1. 线性基内的元素可以通过求异或和，得到原集合的元素任意求异或和得到的所有值。
2. 线性基是满足上面性质的最小的集合。
3. 线性基不存在异或和为 0 的子集。
4. 线性基中，任取不同的子集求异或和，得到的答案不同。（即线性基子集的异或和具有唯一性）
5. 线性基内所有元素的二进制最高位互不相同。



实现 :  对于数集A

1.判断x是否能表示成A的子集异或和

2.x表示成A子集的异或和的方案数

3.求A的最大/最小/第k小异或和

4.求x在A子集异或和中的排名



时间复杂度: query(k),query_rank(x) 都是O(MX*MX) ,其他均为O(MX);

https://www.luogu.com.cn/problem/P3812

```c++
vector<i64> p(MX+1),tmp(MX+1);
bool flag=false;

//获取x的最高位位置(MX-前导0个数)
int get_highest_bit(i64 x) {
    if (!x) return -1;
    return MX-__builtin_clzll(x);
}

//插入
void ins(i64 x) {
    //从高位到低位贪心，确保每一位只有一个基底负责
    for (int i=MX;~i;i--) {
        if ((x>>i)&1) {
            if (!p[i]) {//该位没基底，存入
                p[i]=x;
                return;
            }
            x^=p[i];//异或掉已有基底
        }
    }
    flag=true;//x最终变为0，说明x可以有基底表示
}

//判断x是否能由当前线性基异或得到
bool check(i64 x) {
    for (int i=MX;~i;i--) {
        if ((x>>i)&1) {
            if (!p[i]) return false;
            x^=p[i];
        }
    }
    return true;//最终能消成0
}

//查询max
i64 qmax() {
    i64 res=0;
    for (int i=MX;~i;i--) {
        res=max(res,res^p[i]);
    }
    return res;
}

//查询min
i64 qmin() {
    if (flag) return 0;//插入过程中出现过0
    for (int i=0;i<=MX;i++) {
        if (p[i]) return p[i];
    }
}

//查询第k小异或和
//使每个p[i]在其对应的第i位为1，而在其他基底的第i位为0
i64 query(i64 k) {
    i64 res=0,cnt=0;
    k-=flag;//如果存在0，0是第1小
    if (!k) return 0;

    //高斯消元，使各个基底位独立
    auto pp=p;
    for (int i=0;i<=MX;i++) {
        for (int j=i-1;~j;j--) {
            if ((pp[i]>>j)&1) pp[i]^=pp[j];
        }
        if (pp[i]) tmp[cnt++]=pp[i];//收集非空基底
    }

    //构造第k小：将k进行二进制拆分
    if (k>=(1ll<<cnt)) return -1;//超出范围,不存在
    for (int i=0;i<cnt;i++) {
        if ((k>>i)&1) res^=tmp[i];//选与不选，2^i是已经有了的，用子集思想理解
    }
    return res;
}

//x表示成A子集的异或和的方案数
i64 way(i64 x,int n) {
    if (!check(x)) return 0;//先判断能不能表示
    int cnt=0;
    for (int i=0;i<=MX;i++) {
        if (p[i]) cnt++;
    }

    return (1ll<<(n-cnt));
}

i64 query_rank(i64 x) {
    i64 ran=0,cnt=0;
    vector<i64> q;
    auto pp=p;
    for (int i=0;i<=MX;i++) {
        for (int j=i-1;~j;j--) {
            if ((pp[i]>>j)&1) pp[i]^=pp[j];
        }
        if (pp[i]) q.push_back(pp[i]);
    }

    for (int i=(int) q.size()-1;i>=0;i--) {
        int pos=get_highest_bit(q[i]);
        if ((x>>pos)&1) {
            x^=q[i]; //消去这个基底的影响
            ran+=(1ll<<i);//累加排名贡献
        }
    }

    return ran+flag;
}

void solve() {
    int n;
    cin>>n;
    for (int i=1;i<=n;i++) {
        i64 x;
        cin>>x;
        ins(x);
    }
    cout<<qmax()<<'\n';

}
```



```c++
struct Basis {
    static constexpr int mxb=40;//最高位
    array<pair<u64,u64>,mxb> base;
    //基底值
    //到达该基底所对应的贡献/路径(就是记录是第几个贡献的)

    bool insert(u64 x,u64 mask=0) {//mask不传值=0，否则等于传值
        for (int i=mxb;i>=0&&x;i--) {
            if (~x>>i&1) continue;
            auto &[b,m]=base[i];
            if (~b>>i&1) {
                b=x,m=mask;
                return true;
            }

            x^=b;
            mask^=m;
        }
        return false;//插入失败，早已存在
    }

};
```



https://ac.nowcoder.com/acm/contest/120563/I

## 题目描述

小苯拿到了两个长度为 n 的数组 a,b

小红想让小苯基于这两个数组生成一个新数组 c 需要满足：

- 对于 c[i] = a[i] 或b[i]
- c 异或和为0



思路: 

(a[i] ...)^(b[j]...)=0; 可以转换为 (A ^ a[j])^(b[j])=0; 则A^(a[j]^b[j]...)=0;



```c++
void solve() {
    int n;
    cin>>n;

    u64 val=0;
    Basis pb;
    vector<u64> a(n+1),b(n+1);
    vector<int> id0;
    for (int i=1;i<=n;i++) cin>>a[i],val^=a[i];
    //先筛选出线性无关组
    for (int i=1;i<=n;i++) {
        cin>>b[i];
        if (pb.insert(b[i]^a[i])) id0.push_back(i);
    }

    //再将线性无关组插入,mask标记使用id0中的第几个元素
    Basis pb2;
    for (int i=0;i<id0.size();i++) {
        pb2.insert(b[id0[i]]^a[id0[i]],1ull<<i);
    }

    u64 mask=0;//记录路径
    for (int i=Basis::mxb;i>=0;i--) {//把每一位都清为0
        if (~val>>i&1) continue;
        auto &[v,m]=pb2.base[i];
        mask^=m;
        val^=v;
    }

    set<int> id;
    for (int i=0;i<id0.size();i++) {
        if (~mask>>i&1) continue;
        id.insert(id0[i]);
    }

    if (val!=0) {
        cout<<-1<<'\n';
    }else {
        for (int i=1;i<=n;i++) {
            if (id.contains(i)) cout<<b[i]<<" \n"[i==n];
            else cout<<a[i]<<" \n"[i==n];
        }
    }

}
```

