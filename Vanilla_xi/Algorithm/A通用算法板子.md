# 基础算法板子

[TOC]

# 小总结

（1）注意预测一下一些离谱的样例，看看要不要特判，防t

（2）搞清楚你答案的值是由谁贡献的，实在不行你就去样例那里找规律猜递推式，得出通项

（3）一些保证存在的题，（还有隐式的保存），一般可以进行特值法

​		1）字符串试试删掉所有1或0

​		2）gcd试试用已给值操作

（4）简单题不要想复杂，回归（3）

（5）多步骤类的题，考虑你的步骤顺序真的会影响结果吗，不影响的话去简化

​		1）贪心

​		2）字符串游戏的确认

（6）有的题可能需要你先枚举几遍，即可得出答案

（7）注意某些诈骗题，拿着神秘的题面，其实本质就是高中数学排列组合公式的联想与运用

 

(8) 遇到一串数的，并且与交换有关的，第一时间反应并查集思想，就是一个连通块，由树的思想可知，只需交换一次就可以将两个连通块合并

​		1）有的题目是i与a[i]连通



(9). 正难则反，判它错太难了，那就去找它对的情况



(10). 主对角线的刻画：i+j,副对角线的刻画:i-j



# 复杂度分析

## 时间

![image-20251218084505622](C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251218084505622.png)





* **map,set,multiset**
  * map ， set,  multiset  的插入和查找是 O(nlog n) 的
  * 数组访问是 O(1) 的
  * 当有 10⁵-10⁶ 次操作时，这个 log 因子很关键,一定要慎用！！！！！！
* 1e9跑10秒  



## 空间

1GB= 2e8个int



# 调试

```c++
assert(!stk.empty()); //断言（），如果false,程序会自动报错
```



# 数据

1e18<2的60次

1e9< 2 的30次

```c++
using i8 = int8_t; // [-128, 127]
using u8 = uint8_t; // [0, 255]
using i16 = int16_t; // [-32,768, 32,767]
using u16 = uint16_t; // [0, 65,535]
using i32 = int32_t; // [-2,147,483,648, 2,147,483,647] // 1e9
using u32 = uint32_t; // [0, 4,294,967,295]
using i64 = int64_t; // [-9,223,372,036,854,775,808, 9,223,372,036,854,775,807] // 1e18
using u64 = uint64_t; // [0, 18,446,744,073,709,551,615] // 1e19
```



```c++
using i64 = long long;
using u64 = unsigned long long;
using u32 = unsigned;

using u128 = unsigned __int128;
using i128 = __int128;//是两条下划线
```



<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20260127213241160.png" alt="image-20260127213241160" style="zoom:50%;" />



```c++
// 专门为 i128 准备的输出函数
void print_i128(i128 x) {
    if (x < 0) putchar('-'), x = -x;
    if (x > 9) print_i128(x / 10);
    putchar(x % 10 + '0');
}

// 示例场景：计算 (a * b) % m，其中 a, b, m 都在 10^18 范围
i64 safe_mul(i64 a, i64 b, i64 m) {
    return (i64)((i128)a * b % m);
}
```



# 解绑

```c++
#include<bits/stdc++.h>
using namespace std;

using i64=long long;
using u64=unsigned long long;
using f80=long double;
using i128=__int128;//-2e127~2e127-1,使用时要用快读快写

constexpr int mxn=5e5+5;
constexpr int inf=1e9;
constexpr i64 infl=1e18;
constexpr i128 infll=i128(1)<<100;


void solve() {


}

int main() {
    ios::sync_with_stdio(false);
    cin.tie(nullptr);

    int t=1;
    cin>>t;
    while(t--) {
        solve();
    }
    return 0;
}
```



# 快读快写

```c++
//（用的时候可以把解绑注释了）
i128 read() {
    i128 sum = 0, fl = 1;
    i128 ch = getchar();
    for (; !isdigit(ch); ch = getchar()) if (ch == '-') fl = -1;
    for (; isdigit(ch); ch = getchar()) sum = sum * 10 + ch - '0';
    return sum * fl;
}
 
void write(i128 x) {
    if (x < 0) putchar('-'), x = -x;
    if (x > 9) write(x / 10);
    putchar(x % 10 + '0');
}
```



# 注意

（1）构造n个c;

​	`string (n,'c');`

​	`cout<<string (n,'c');`



（2）构造`vector`

​	`vector s(n,string (n,'c'));`

(3) 

```c++
 substr()

​	string a;

​	int i;

​	string t=a.substr(i)+a.substr(0,i);
```

先将从i到最后提出来，再将0到i-1的部分提出来到后面；全过程为引用

 

(4)  `set<int> q`  好用

​	`set <int> q;`

​	存储唯一的元素，即每个元素只出现一次`int tp;`

​	`q.insert(tp) ;`

​	存元素,会自动升序 `int cnt=q.size();` 统计



(5) `unique` 只能去除相邻重复元素，因此使用前要先`sort`,最后记得减`aa.begin()`

```c++
vector<int> aa(10);

​	sort(aa.begin(),aa.end());

​	int ans=unique(aa.begin(),aa.end())-aa.begin();
```

(6)`lower_bound`(目标始， 目标终，值) 返回第一个`a[i]>=value`的i

​    `upper_bound`(目标始， 目标终，值) 返回第一个`a[i]>value`的i



(7)还有那种不定长度的`vector<int> a`

`if(...) a.push_back(x)`

(8)引用数组

`bool check(vector<int> &arr,int now) chek(arr,mid)`

 

(9)

```c++
vector<int> a; int n;
cin>>n ;
a.assign(n+1,0);将a中重新分配(n+1)个元素，元素全赋值为0
```

(10)降序

`sort(a.begin(),a.end(),greater<int>()); <int>`也可以不写



（11）初始化

`memset(a,0,sizeof(a));`

 

（12）小数

`cout<<fixed<<setprecision(2)<<dis[ed]<<'\n';`

 

（13）

`isdigit(); isalpha(); isalnum(); isupper(); islower(); toupper(); tolower();`

`char`只能存一个数字/字母

（14）

涉及数据的运算，最好统一类型,int,i64，有时候强制类型转换也过不了

 

（15）累加

`ll len = accumulate(ct.begin(), ct.end(), 0ll) ;`



（16）

`auto d=f;` 整个数组给他拷过去

（17）

`(x+p)%p;`  确保非负

（18）

移位记得1ll*

(19)

```c++
2^31<3e9  , 2^60<2e18

int: -2^31到2^31-1  (-2,147,483,648到2,147,483,647)

long long :-2^63到2^63-1  (-9,223,372,036,854,775,808到9,223,372,036,854,775,807)


```

(20)

使用 `(n + p - 1) / p * p`计算大于等于n的最小p的倍数

使用`(b+x-1)/x`代替`ceil(double(b/x))`



（21）`memcpy(dp2, dp1,sizeof(dp1))` 把dp1的内容复制到dp2

 

（22）

```c++
string a,b,c;
cin >> a;
b.resize(a.size());//不可缺，否则段错误
c.resize(a.size());
b=a;
reverse(b.begin(),b.end());
```



(23)

```c++
    sort(a.begin(),a.end());
    a.erase(unique(a.begin(),a.end()), a.end());
```



(24)  bool cmp 函数里面必须是<,>不能<=,>=会re



# 强制类型转化

```c++
ans=max<int>(ans,adj[i].size());
```



# 基础的函数

## 内置版

### 二进制

```c++
(1) 二进制
int x = __lg(n); //二进制中最高位为1的位置，(两条下划线)

 __builtin_ctz(a) //返回二进制末尾 0 的个数，(两条下划线，一条)
// 这里用于找到 a 中最低位的 1，并将其转换回对应的字母 'a' - 'z'

 __builtin_ctz(a) //找前导0     
 __builtin_popcount(a) // 返回二进制值为1的位的个数，状压时可快速判断集合有多少元素 ;汉明距离  

__lg(x)//计算x的最高位所在位置 __lg(1)  = 0  

```



### 字符串

```c++
(2)字符串
数字转为string:(以下数据类型都可以)
int a;
double b;
long long c;

string aa=to_string(a);

ans.substr(pos, len)//从pos开始提取长度为len的子串
    
puts("Yes");//输出，会自动换行
putchar(' ');//输出
```



### 范围

```c++
 t1=clamp(t1,lo,hi);//把t1限制在[lo,hi]里,若本身满足则不变，小于则lo，大于则hi
```





## 手写版

### 位运算

```c++
//返回最低位的1
int lowbit(int x) {
    return x&-x;
}

//获取x的最高位位置(MX-前导0个数)
MX=63;
int get_highest_bit(i64 x) {
    if (!x) return -1;
    return MX-__builtin_clzll(x);//函数返回的是64位下的
}
```



### 取整

```c++
//向上取整(大)
i128 udiv(i128 a, i128 b) {
    if (a >= 0) return (a + b - 1) / b;
    return a / b;
}

//向下取整
i128 ddiv(i128 a, i128 b) {
    if (a >= 0) return a / b;
    return (a - b + 1) / b;
}
```





# 内部函数

## lambda

### auto

```c++
    auto cek=[&](int x) {
       
    };//[]里的是捕获solve里all的东西，()是传递到cek里的
```



### 可再lambda里调用型

```c++
    auto find=[&](auto &&self,int x)->int {//箭头指向返回值类型，一定要写
        return x==fa[x]? x: fa[x]=self (self,fa[x]);//注意这个调用自身的参数要用self
    };


   find(find,1);//在外面调用时
```



```c++
    auto find=[&](auto &&self,int x)->int {
        return x==fa[x]? x: fa[x]=self (self,fa[x]);
    };
```



## 递归调用型function

比lambda慢，不用

```c++
    function<int (int,int)> dfs=[&](int u,int v) {
        int ans;

        return ans;
    };
//function<返回类型(接收类型)> dfs=[&捕获](传递){};
```



## 写在sort里的cmp

```c++
sort(a.begin()+1,a.begin()+n/2+1,[](auto &x,auto &y){return x[1]<y[1];} );
```



# 外部函数

```c++
void add(i64 &x,i64 y) {//加了&可以修改x
    x=((x+y)%P+P)%P;
}
```



# 结构体排序

## 重载运算符

```c++
struct func {
    i64 a,b,c;
    int id;

    friend bool operator<(func a,func b) {
        if (a.a!=b.a) return a.a<b.a;
        return a.c<b.c;
    }
};
```



# 爆搜



> (1). DFS解决最短路径问题，地毯式搜索
> 每组搜索中的点距离出发点相同，不会重复搜
>
> (2).  BFS解决方案数问题（深度搜索，递归多次）
> 不仅仅要在搜到时return,还要对其他一些情况进行剪支，或考虑能否不开vis数组，不然很容易t



###### BFS

```c++
#include <bits/stdc++.h>
using namespace std;
int main()  {
    int sx,sy,ex,ey,n,m;
    cin>>n>>m;
    cin>>sx>>sy>>ex>>ey;//先读入起始点
    //开数组设选择,记得补啊，一般为走法
    int num;
    cin>>num;
    vector<int> xx(num) ;
    vector<int> yy (num);
    //开答案数组，标记数组
    vector <vector<int> > ans(n+1,vector<int>  (m+1));
    vector <vector<int> > vis(n+1,vector<int>(m+1));
    //初始化，第一个节点
    int x,y,step=0;
    queue<int> qx,qy,qstep;
    qx.push(sx),qy.push(sy),qstep.push(step);
    //bfs
    while  (!qx.empty ())  {
        x=qx.front(),qx.pop ();
        y=qy.front(),qy.pop ();
        step=qstep.front(),qstep.pop ();
        for  (int i=0;i<num;i++)  {
            int tx=x+xx[i],ty=y+yy[i];
            if  (tx>0&&tx<=n&&ty>0&&ty<=m&&vis[tx][ty]==0)  {
                vis[tx] [ty]=1 ;
                qx.push(tx) ;
                qy.push(ty) ;
                qstep.push(step+1) ;
                ans[tx][ty]=step+1 ;
            }
        }
    }
    return 0; }

```



###### DFS

www.luogu.com.cn/problem/P1605

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251206143313271.png" alt="image-20251206143313271" style="zoom:33%;" align="left"/>



```c++
void dfs(int x,int y) {
    if (x==fx&&y==fy) {
        cnt++;
        return;
    }

    for (itn i=0;i<4;i++) {
        int tx=x+dx[i];
        int ty=y+dy[i];
        if (tx>0&&tx<n&&ty>0&&ty<m&&(!mp[tx][ty])) {
            mp[tx][ty]=1;
            dfs(tx,ty);
            mp[tx][ty]=0;
        }
    }
}
```



###### 记忆化搜索

> 其实就是开一个数组记录搜过的，下次直接用



www.luogu.com.cn/problem/P1434



<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251206143928184.png" alt="image-20251206143928184" style="zoom:33%;" align="left"/>



```c++
int n,m;
vector<vector<int>> mp;
vector<vector<int>> cnt;
int dx[4]={0,0,1,-1};
int dy[4]={1,-1,0,0};
int dfs(int x,int y) {
    if (cnt[x][y]) return cnt[x][y]; cnt[x][y]=1;
    for (int i=0;i<4;i++) {
        int tx=x+dx[i],ty=y+dy[i];
        if (tx>0&&tx<=n&&ty>0&&ty<=m&&mp[tx][ty]<mp[x][y]) {
            cnt[x][y]=max(cnt[x][y],dfs(tx,ty)+1);
        }
    }
    return cnt[x][y];
}
```







# 二分

> key: 单调，最值，范围
>
> 即可考虑二分答案，cek





> 二分可以是 :
> 1.答案
> 2.求答案时要用的值
> 3.后续步骤应清楚r<l跳出来，（r=l-1,mid视情况），因为后续可能还要用到，可能卡t



```c++
int l,r,mid;
    while  (l<=r)  {
        mid=(l+r)/2 ;
        查找
        改变循环条件
        if  () l=mid+1;
        else r=mid-1 ;
    }
```



更喜欢这个

```c++
while (r-l>1) {
        mid=(l+r)/2;
        if (check(mid)) r=mid;
        else l=mid;
    }
```





```c++
    int l=1,r=n+1;//记得给r设一个越界值
    while (l<r) {
        int mid=(l+r)>>1;
        if (check(mid)) r=mid;
        else l=mid+1;
    }//然后ans直接为l=r,因为只要不越界n,r必定合法
```



边二分边确定答案，保险点

```c++
    int l=1,r=a[n],mid,ans=0;
    while (r>=l) {
        mid=(l+r)>>1;
        if (check(mid)) l=mid+1,ans=mid;
        else r=mid-1;
    }
```





[小红的矩阵_牛客题霸_牛客网](https://www.nowcoder.com/practice/eec2ed5b48b04a1492209ba08593a830?channelPut=tracker2)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251211194424822.png" alt="image-20251211194424822" style="zoom:33%;" align="left"/>

```c++
i64 cek(i64 x) {
    i64 res=0;
    for (i64 i=1;i<=n;i++) {
        res+=min(m,x/i);
        if (x/i==0) break;
    }
    return res;
}


void solve() {
    cin>>n>>m>>k;

    i64 l=1,r=n*m;
    i64 ans=0;
    while (l<=r) {
        i64 mid= (l+r)>>1;
        if (cek(mid)>=k) {
            ans=mid;
            r=mid-1;
        }else l=mid+1;
    }

    cout<<ans<<'\n';
}
```



## 优先队列（好题）

[P3611 [USACO17JAN\] Cow Dance Show S - 洛谷](https://www.luogu.com.cn/problem/P3611)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251216183906743.png" alt="image-20251216183906743" style="zoom:33%;" align="left"/>

使用小根堆来维护每个位置的结束时间，模拟

```c++
    auto cek=[&pq,&n,&a,&t] (int x) {
        int res=0;
        for (int i=1;i<=x;i++) {
            pq.push(a[i]);
        }

        int y=0;//前者结束时间
        for (int i=x+1;i<=n;i++) {
            res+=pq.top()-y;//超出时间，就要加上
            y=pq.top();
            pq.pop();
            pq.push(a[i]+y);
        }

        if (res>t) return false;

        while (x--) {
            res+=pq.top()-y;
            y=pq.top();
            pq.pop();
        }
        if (res<=t) return true;
        return false;
    };
```



## 例题

[Problem - A - Codeforces](https://codeforces.com/contest/335/problem/A)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251227122143055.png" alt="image-20251227122143055" style="zoom:50%;" />

* 注意到，纸张数和纸张容量线性相关（单调），考虑二分答案，就是二分纸张数，check的话就是找出该限制下每个不同字符在一张纸张上ceil最少出现数，看看满不满足<=len,
* 这里如果多了的位置我们只需要最后输出相应个a即可



* 贪心是假的，（先填入各字母一次，在优先填剩得最多的），已找到反例
  aaaaaabbbcc 6
  必须二分答案了，因为决定你纸张数的不是字符的出现数量，而是（字符在ans纸张中的出现数量/该字符所需数量），上一点已经暗示你贪心wa
* 接下来放出这道题，注意那个倒数第二点



<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251227123054408.png" alt="image-20251227123054408" style="zoom:33%;" align="left"/>

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251227123024948.png" alt="image-20251227123024948" style="zoom: 33%;" align="left"/>







# 三分

> 解决非单调且是单峰函数最值， 自己可以根据函数的对称性之类的进行判断



```c++
double l=-10000.0,r=10000.0,m1,m2;
    for (int i=1;i<=100;i++) {
        double len=(r-l)/3;
        m1=l+len,m2=r-len;
        if (query(m1)>query(m2)) l=m1;//根据函数性质自己改
        else r=m2;
    }
```



整数型（有坑）

```c++
    i64 ans=max(query(l),query(r));
     while (r-l>3) {
         i64 m1=l+(r-l)/3;
         i64 m2=r-(r-l)/3;

         if (check(m1)<check(m2)) l=m1;
         else r=m2;
     }

	    // 最后在剩余的 [l, r] 极小区间内暴力查找，彻底杜绝边界问题
    ll ans = l;
    for (long long i = l + 1; i <= r; i++) {
        if (check(i) > check(max_x)) ans=i;
    }
```



# 排序

## 冒泡排序

```c++
void solve() {
    int n;
    cin>>n;
    vector<int> a(n);

    for (int i=0;i<n;i++) {
        bool ok=false;
        for (int j=0;j<n-i-1;j++) {
            if (a[i]>a[i+1]) {
                swap(a[i],a[i+1]);
                ok=true;
            }
        }

        if (!ok) break;
    }
}
```





# 前缀和

> 可以与字符串结合起来考前，后缀和
>
> 本质就是对前，后的计数，不一定要数组



## 一维

```c++
void solve() {
    int n;//数组长度
    cin >>n;
    vector <int> pre(n+1) ;
    //存储每个位置的前缀和
    int temp;//读入值a[i];
    for  (int i=1;i<=n;i++)  {
        cin >> temp;
        pre[i]=pre[i-1]+temp;
    }
    int begin,end,ans=0;//读入区间
    cin >> begin >> end;
    ans=pre[end]-pre[begin-1];//别误写成pre[x] cout << ans << endl  ;

}
```



## 二维

```c++
void solve() {
    int n,m,q;//长度，询问次数
    cin>>n>>m>>q;
    vector<vector<int> > pre(n+1,vector<int>(m+1));
    int temp;
    for(int i=1;i<=n;i++)  {
        for(int j=1;j<=m;j++)  {
            cin>>temp;
            pre[i][j]=pre[i-1][j]+pre[i][j-1]-pre[i-1][j-1]+temp;//两头减小加特值
            }
        }

    int u,v,x,y,sum;
    for  (int i=1;i<=q;i++)  {
        cin>>u>>v>>x>>y;
        sum=pre[x][y]+pre[u-1][v-1]-pre[x][v-1]-pre[u-1][y];//大加小减两头
    }
}
```





# 后缀和

```c++
void solve() {
    int n;
    string s;
    cin >> n >>s ;
    vector<int> suf(n+2,0);//一定n+2,防溢出string s;
    cin>>s;
    //倒序
    for  (int i=n;i>=1;i++)  {
        suf[i]=suf[i+1]+s[i-1];
    }
    int begin,end,ans;
    ans=suf[begin]-suf[end+1] ;
}
```





# 差分

## 一维

```c++
void solve() {
    int n,p;//数字个数，改动次数
    cin >> n >> p;
    vector<int>a(n+1,0),b(n+1,0);//原数组，差分数组
    for  (int i=1;i<=n;i++)  {
        cin >> a[i];
        b[i]=a[i]-a[i-1] ;
    }
    while  (p--)  {
        int x,y,z;//改动区间，大小
        cin >> x >> y >> z;
        b[x]+=z ;
        b[y+1]-=z;//注意是y+1
    }
    //求前缀和，b[n]的前缀和即为更新后的a[n]
    int ans=根据题目设
    for  (int i=1;i<=n;i++)  {
        b[i]+=b[i-1];//这里直接把数组b当成前缀和数组
        ans=max或min(ans,b[i]);//更新
    }
    cout << ans << '\n';
}
```



## 二维

```c++
void solve() {
    int n,m,q;
    cin>>n>>m>>q;
    vector <vector<int> >a(n+2,vector<int>(m+2));//注意要n+2,防止接下来越界
    while  (q--)  {
        int x1,y1,x2,y2,z;
        cin>>x1>>y1>>x2>>y2>>z;
        a[x1][y1]+=z;//对角值++
        a[x2+1][y2+1]+=z;
        a[x1][y2+1]-=z;//越界值--
        a[x2+1][y1]-=z;
    }
    //计算前缀和
    for  (int i=1;i<=n;i++)  {
        for  (int j=1;j<=m;j++)  {
            a[i][j]+=a[i-1][j]+a[i][j-1]-a[i-1][j-1];//两头减小加特值，特值已为a[i][j]
            }
    }
}
```



## 二阶差分

### 点型写法

a[i]就是该点的斜率，没平缓段时好用

[P5026 Lycanthropy - 洛谷](https://www.luogu.com.cn/problem/P5026)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251217130941210.png" alt="image-20251217130941210" style="zoom:33%;" align="left"/>



<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251217131047768.png" alt="image-20251217131047768" style="zoom: 33%;" align="left"/>



> 画个图，因变量y表示要加到作用区间上的值，y是线性的，那么我们可以对y的增量进行差分维护，其实也可以理解成斜率

```c++
    vector<int> a(m+2*mxn+5),b(m+2*mxn+5);//a为差分的差分
    while (n--) {
        int v,x;
        cin>>v>>x;
        a[mxn+x-3*v+1]++;
        a[mxn+x-2*v+1]-=2;//-1的话其实是不变操作，但这里得下降，所以-2
        a[mxn+x+1]+=2;
        a[mxn+x+2*v+1]-=2;
        a[mxn+x+3*v+1]++;//+1是不变操作
    }

    for (int i=1;i<m+2*mxn+5;i++) {
        a[i]+=a[i-1];
        b[i]+=b[i-1]+a[i];//这里用的是该点的斜率，因为没有平缓段，方便
    }

```



### 区间型写法

有平缓段是必须这样，a[i]是点i到i+1的斜率

[G-小红越级（hard）_牛客小白月赛126](https://ac.nowcoder.com/acm/contest/125955/G)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251228172855053.png" alt="image-20251228172855053" style="zoom: 45%;" align="left"/>



```c++
void solve() {
    int n,q;
    cin>>n>>q;
    vector<int> a(n+3),b(n+3);//斜率，截距
    for (int i=1;i<=n;i++) {
        int x,y;
        cin>>x>>y;
        if (x>1) {//是i-1点到i点的斜率
            a[x-1]++;
            a[1]--;
            b[1]+=x-2;
        }
        if (y-x>3) {
            a[x+1]++;
            a[(x+y)/2]--;
            a[(x+y+1)/2]--;
            a[y-1]++;
        }
        a[y+1]++;
    }

    for (int i=2;i<=n;i++) {
        a[i]+=a[i-1];
        b[i]=b[i-1]+a[i-1];//是i-1点到i点的斜率
    }
```







# 离散化

> 将数据变索引，因为只关注数据相对大小



> 逆序对，冒泡排序的题用了



## 模板

```c++
    int n;
    cin>>n;
    vector<int> a(n+1);
    for (int i=1;i<=n;i++) {
        cin>>a[i];
    }
    auto b=a;
    sort(b.begin(),b.end());//还是得让a[0],b[0]参与，不然老是出现问题
    b.erase(unique(b.begin(),b.end()),b.end());
    for (int i=1;i<=n;i++) {
        a[i]=lower_bound(b.begin()+1,b.end(),a[i])-b.begin()+1;
    }
```



已亲测，从1开始也ok,两种都ok

```c++
    sort(d.begin()+1,d.end());
    d.erase(unique(d.begin()+1,d.end()),d.end());
    for (int i=1;i<=n;i++) {
        a[i]=lower_bound(d.begin()+1,d.end(),a[i])-d.begin();
        b[i]=lower_bound(d.begin()+1,d.end(),b[i])-d.begin();
    }
```



## 例题

### 区间长度

```c++
void solve() {
    i64 n;
    cin>>n;
    vector<i64> a(n),b(n);
    for  (int i=0;i<n;i++)  {
        cin>>a[i]>>b[i];
    }
    sort(a.begin(),a.end());//起点
    sort(b.begin(),b.end());//终点
    
    i64 ans=0;
    for (int i=0;i<n;i++) {
        ans+=b[i]-a[i];
        if (i<n-1) {
            if (b[i]>a[i+1]) {
                ans-=b[i]-a[i+1];
            }
        }
    }

    cout<<ans<<'\n';
}
```



### 逆序对

```c++
void solve() {
    int n ;
    cin>>n ;
    vector<int> a(n+1),rk(n+1) ;
    for (int i=1;i<=n;i++) {
        cin>>a[i] ;
        rk[i]=a[i] ; 
    }
    //离散化，变索引
    sort(rk.begin()+1,rk.end()) ;
    unique(rk.begin()+1,rk.end()) ;
    for (int i=1;i<=n;i++) {
        a[i]=lower_bound(rk.begin()+1,rk.end(),a[i])-rk.begin() ;
        //别再减1，否则min的索引会变为0
    }
}
```





# 双指针



> （1）一般用于连续段的计数
> （2）要选好指向的对象以实现下一轮的l=r
> （3）有时循环变量i也能充当r



## 例题

> 一个序列的重排列是指对这个序列中的元素进行若干次(包括0次)交换操作后得到的新序列在本题中，序列中可能出现重复的数字，他们被视作不同的元素例如，序列11的重排列有两种现在有两个长度为N的非负整数序列A和B,问有多少种A的重排列满足对于所有的1SisN,有ASB
> 由于答案可能很大，你只需要输出答案对1e9+7取模的结果



双指针+排序+DP

```c++
    sort(a.begin()+1,a.end());
    sort(b.begin()+1,b.end());
    vector<i64> ans(n+1);
    int l=0;
    ans[0]=1;
    for (int i=1;i<=n;i++) {
        while (l<=n&&a[l]<=b[i]) l++;

        if (l-i<=0) {
            cout<<0<<'\n';
            return;
        }

        ans[i]=1ll*ans[i-1]*(l-i)%P;
    }
```





> 给定一个长度为n的排列p,您必须按照顺序对从1到n的每个整数k执行一次操作：
> 选择长度为p的长度为k的子数组，并从该子数组中的每个元素减去1。在完成所有n操作后，您的目标是使数组的所有元素都等于零。确定是否有可能实现这一点

```c++
void solve() {
    int n;
    cin>>n;
    vector<int> a(n+1),b(n+1);
    for (int i=1;i<=n;i++) {
        cin>>a[i];
        b[i]=a[i];
    }
    
    sort(b.begin()+1,b.end());
    int l,r;
    for (int i=1;i<=n;i++) {
        if (a[i]==b[n]) {
            l=i-1;
            r=i+1;
            break;
        }
    }
    
    int pos=n-1;
    while (pos>=1) {
        if (l>=1&&a[l]==b[pos]) {
            l--;
            pos--;
        }else if (r<=n&&a[r]==b[pos]) {
            r++;
            pos--;
        }else {
            cout<<"NO\n";
            return;
        }
    }
    cout<<"YES\n";
}
```



> 您想购买价格为a1,a2,…,an的产品n。您可以：-单独购买产品i,支付a;硬币，或-使用折扣券购买，作为团购的一部分。
> 您有值为b₁,b2,…,bk的折扣券。价值为x的代金券允许您精确地选择z产品，并且只支付（z-1）最贵的产品，因此，您可以认为组中最便宜的产品是免费的。每个产品最多可以包含一个**折扣组，即使它不是免费的。此外，任何一张代金券最多只能使用一次。购买所有n产品所需的最低总成本是多少?



```c++
sort(a.begin()+1,a.end());
    sort(b.begin()+1,b.end());
    int l=n,r=1;
    while (r<=k&&l>=1) {
        int tp=b[r];
        if (tp>l) break;
        ans-=a[l-tp+1];
        l-=tp;
        r++;
    }
```



> 回想一下，长度为n的排列是长度为n的序列，其中从1到n的每个整数都正好出现一次。让我们把一个排列的代价定义为需要排序的连续子段(可能是空)的最小长度，这样整个排列就可以按升序排序。给你一个整数数组p,由从0到n的整数组成，其中没有一个正整数(严格大于零)出现超过一次。你应该用整数替换零，使数组p成为一个排列。你的任务是计算所得到的排列的最大可能代价。



关键在0的处理,用两个双指针,若只有1个0，那他的值确定
l,r的维护用三个量是因为不确定0的改值是否正序，若是其实两个量即可，若不是则0位置必须被记录（3个量）

若有两个以上的0，则可以把0都当成乱序，正常考虑了



```c++
int l=inf,l0=inf,r=0,r0=0;
    for (int i=1;i<=n;i++) {
        if (!a[i]) {
            l0=min(l0,i);
            r0=max(r0,i);
            continue;
        }
        if (a[i]!=i) {
            l=min({l,i,a[i]});
            r=max({r,i,a[i]});
        }
    }

    if (l0<r0) {
        l=min(l,l0);
        r=max(r,r0);
    }

    if (l<r) cout<<r-l+1<<'\n';
    else cout<<0<<'\n';
```



> Teto正在玩热门节奏游戏《osu!》游戏可以用一个长度为n的二进制字符串*s和一个正整数k来描述，其中以下将依次发生：
> 你将选择s中的一些位置来保护。然后，对于每一个i(1≤i≤n)按递增的顺序，Teto可以将s[i]设置为0,如果以下所有条件都为真：
>
> s[i]=1
> s[i]不受保护，
> 前面的k-1元素不包含1（更正式地说，1没有出现在Smax(1,1-k+1)。
>
> 你不喜欢Teto(出于某种原因)。因此，确定您需要保护的最小位置数，以迫使她保持s不变。二进制字符串是由字符0和1组成的字符串。



双指针追踪1的位置





# 交互题

### 询问与回答的封装

```c++
void solve() {
    auto ask=[&](vector<int> arg)->int {
        cout<<"? "<<flush;
        for (int i=0;i<(int)arg.size();i++) {
            cout<<arg[i]<<" ";
        }
        cout<<'\n'<<flush;
        int res;
        cin>>res;
        return res;
    };
    
    int n;
    cin>>n;
    vector<int> arg1(n),ans(n);
    //询问及询问后的操作
    
    cout<<"! ";
    for (int i=0;i<n;i++) {
        cout<<ans[i]<<" ";
    }
    cout<<'\n'<<flush;
}
```



### 例题

> 这是该问题的简单版本。不同版本之间的区别在于，在此版本中，你可以查询长度为n的任意序列。定义：一个长度为n的排列是指由1到n的所有整数构成，每个数恰好出现一次的序列。现在有一个长度为n的未知排列p.
> 为了确定排列p,你可以进行最多n²次查询，每次查询方式如下：
>
> * 输出一个长度为n的任意序列a.
>
> * 交互器会计算a与p在同一位置上数值相同的个数k(即满足a[i]=p[i]的i的数量),并输出该k 值。
>
>   
>
>   在完成最多n²次查询后，你需要输出排列p的全部元素。
>   请注意，排列p是在任何查询之前就固定的，且不依赖任何查询。



逐位查询， (1到n),并令其他位=0，res=1，则记录ans



> 这是该问题的困难版本。不同版本之间的区别在于，在此版本中，你只能查询长度为n的排列。定义：一个长度为n的排列是指由1到n的所有整数构成，每个数恰好出现一次的序列。现在有一个长度为n的未知排列p。
> 为了确定排列p,你可以进行最多n²次查询，每次查询方式如下：
>
> * 输出一个长度为n的排列a。
>
> * 交互器会计算a与p在同一位置上数值相同的个数k(即满足a[i]=p[i]的i的数量),并输出该k 值。
>
>   
>
>   在完成最多n²次查询后，你需要输出排列p的全部元素。
>   请注意，排列p是在任何查询之前就固定的，且不依赖任何查询。



从i=1开始，不断swap,如果res增大则保留不换回，否则换回来



https://codeforces.com/problemset/problem/2013/C

> Shoutyu会持有一个长度为n的二进制字符串s,同时告诉你n的长度。对于每次猜测，你需要给出一个二进制字符串t,Shoutyu将告诉你t是否是他手上持有的这个二进制字符串的子串，保证Shoutyu手上持有的字符串8不会改变。
> 当然，如果你尝试的时间太久，大保险就自动开启了，所以你需要在不超过2×n次操作中找到正确的密码。
> 输入输出格式
> 这是一道交互题，交互时，需要在读取输入后发送输出并刷新缓冲区。
> 第一行一个整数n(1≤n≤100),表示二进制字符串的大小，然后开始交互。
>
> 在交互阶段，你可以进行至多2×n次查询和一次提交，提交过后测试立刻终止。



先ans后面不断加字符，0，1各查询2次，若2次均为no,则目前ans为后缀，往前加就好了



> 你有20只小动物和两瓶神奇的毒的。
> 你可以选一批药，每一瓶果样一点。得到的混合药剂顺给一只小动物。如果小动物服用了混合了毒药的药剂，就会死亡，出于人道，服过药的小动物即便没有死亡也不族再服药，
> 两瓶毒药被随机混在了998瓶任何性质都充全一样的缩剂中(一共有1000瓶),我们认为溶剂不会对小动物有任何额外影响。
> 请在20只小动物全部用尽之前找出两瓶毒的对应的编号。
> 输入输出格式
> 这是一道交互题，交互时，需要在读取输入后发送输出井刚新暖冲区，
> 在交互阶段，你可以进行任意次直询和一次提交，但对直询有所限制，提交过后测试立刻峰止。对于每次查询，在第一行输入?n.整数n表示小鼠的组数。
> 在之后的n行中，每一行先输出一个整数ag,表示第4细小细的个数，然后输出a;个数，分影表示此小组的的瓶编号，之间用空格隔开，
> 在所有n+1行信息相输出完成之后，你所要从疆冲区读入n个整数c(1≤i≤n),分别表示第组小动物的存适情况，0表示死亡，1表示存活，保证所有c∈0,1
> 对于每一次查询，你需要保证所有a;≤1000旦每个药的编号各不相网
> 对于所有查询，你需要保证∑n≤20
> 如果你的交互格式有误或分组数量的家和罐过20程序会立制终止，判定为WA。



其实就是二分，关键在于代码的实现：
 case1:区间含2
可能可以转到case2
case2:区间含1
起始状态是case1

```c++
void print(int l,int r) {
    cout<<r-l<<endl;
    for (int i=l;i<r;i++) {
        cout<<i<<" ";
    }
    cout<<endl;
}

int f1(int l,int r) {//区间只含1个
    if (r-l==1) return l;
    int mid=(l+r)/2;
    cout<<"? 2"<<endl;
    print(l,mid);
    print(mid,r);
    int k1,k2;
    cin>>k1>>k2;
    return !k1? f1(l,mid): f1(mid,r);
}

pair<int,int> f2(int l,int r) {//含2个
    int mid=(l+r)/2;
    if (r-l==2) return{l,l+1};
    cout<<"? 2"<<endl;
    print(l,mid);
    print(mid,r);
    int k1,k2;
    cin>>k1>>k2;
    if (!k1&&!k2) return {f1(l,mid),f1(mid,r)};
    return !k1?f2(l,mid):f2(mid,r);
}

void solve() {
    auto [i,j]=f2(1,1001);//左闭右开
    cout<<"! "<<i<<" "<<j<<endl;
}
```



> 

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251206155453655.png" alt="image-20251206155453655" style="zoom:33%;" align="left"/>



首先拿0试，得到ans有多少个1即为cnt,接着i从0到60给1移位，res>cnt,则该位为0，否则为1，我们ans^=tp





# 预处理



### (1) 密码表

###### 结构体

```c++
struct node {
    int x,y;
};

void solve() {
    string s[5]={
        "PLAYF",
        "IRBCD",
        "EGHKM",
        "NOQST",
        "UVWXZ",
    };
    vector<node> a(26);
    for (int i=0;i<5;i++) {
        for (int j=0;j<5;j++) {
            a[s[i][j]-'A']={i,j};
        }
    }
}
```



###### pair

```c++
void solve() {
    string s[5]={
        "PLAYF",
        "IRBCD",
        "EGHKM",
        "NOQST",
        "UVWXZ",
    };
    
    vector<pair<int,int>> a(26);
    for (int i=0;i<5;i++) {
        for (int j=0;j<5;j++) {
            a[s[i][j]-'A']={i,j};
        }
    }
    auto [x,y]=a['P'-'A'];//使用
}
```



# py处理高精度

一般为2^1000级别

```python
import sys
# 将字符串转整数的上限设为 100000 位（或更高）
sys.set_int_max_str_digits(100000)

```



```python
import sys

# 增加递归深度，防止深度 DFS 时崩溃
sys.setrecursionlimit(200000)

# 快速输入（处理大数据量时必用）
input = sys.stdin.readline

def solve():
    # Python 自动处理高精度
    a = int(input())
    b = int(input())
    
    print(a + b)
    print(a * b)
    print(a // b)  # 注意：Python 的 / 是浮点除，// 才是整除
    print(a % b)
    print(pow(a, b, 10**9 + 7)) # 快速幂：(a^b) % m

if __name__ == "__main__":
    solve()
```



















































