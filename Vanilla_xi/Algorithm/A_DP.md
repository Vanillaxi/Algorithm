# DP

[TOC]

# 前言

对于DP,时间复杂度= 状态个数*转移个数





# 背包DP

### 01背包

#### 普通

```c++
void solve() {
    int n,m;
    cin>>n>>m;
    vector<int> w(n+1),v(n+1),dp (n+1);
    for  (int i=1;i<=n;i++)  {
        cin>>w[i]>>v[i];
    }
    for  (int i=1;i<=n;i++)  {//先遍历物品
        //后遍历背包，记得倒序，因为每个物品只能选一次，这里保证每一次外层循环中内层循环所调用的dp都还没装那一种物品
        for  (int j=m;j>=w[i];j++)  {
            dp[j]=max(dp[j],dp[j-w[i]]+v[i]);
        }
    }
}
```



#### 方案数

求在A_i 物品中选择，和为m 的方案数

* 折半搜索， 35<=n<=40，0<=m<=1e12 时间复杂度O(2*2^(n-1));  (2e6左右)，unordered _map 时间复杂度O(1)
  * 分别统计左右两半的和的所有可能情况，再存入哈希表中，再统计

```c++
    vector<i64> a(n);
    for (int i=0;i<n;i++) {
        cin>>a[i];
    }

    int mid=n/2;
    vector<i64> l(1),r(1);
    for (int i=0;i<mid;i++) {
        i64 x=a[i];
        int t=l.size();
        for (int j=0;j<t;j++) {
            l.push_back(x+l[j]);
        }
    }

    for (int i=mid;i<n;i++) {
        i64 x=a[i];
        int t=r.size();
        for (int j=0;j<t;j++) {
            r.push_back(x+r[j]);
        }
    }

    i64 ans=0;
    unordered_map<i64,i64> mp;
    for (auto i:l) mp[i]++;

    for (auto i:r) {
        if (mp.count(m-i)) ans+=mp[m-i];
    }

```



### 完全背包

##### 最大价值

> 内层循环必须先物品再背包，因为状态转移方程需要利用同一层已更新的状态

```c++
void solve() {
    int n,m;
    cin>>n>>m;
    vector<int> w(n+1),v(n+1),dp (n+1);
    for  (int i=1;i<=n;i++)  {
        cin>>w[i]>>v[i]; 
    }
    for  (int i=1;i<=n;i++)  {//先遍历物品
        for  (int j=1;j<=m;j++)  {//再遍历背包，记得正序，因为一件物品可以重复选
            if (j>=w[i]) dp[j]=max(dp[j],dp[j-w[i]]+v[i]);
        }
    }
}
```

##### 方案数

```c++
void solve() {
    int m,n;//背包容量，方案数
    cin>>m>>n;
    vector<int>a(n+1) ;
    for  (int i=1;i<=n;i++)  {
        cin>>a[i];
    }
    int ans=0;
    vector<int>dp (m+1);//记录方案数
    for  (int i=1;i<=m;i++)  {//先遍历背包
        for  (int j=1;j<=n;j++)  {//再遍历选择方案
            if(i+j>m) break;
            if  (i>=a[j]) dp[i+j]+=dp[i];//末状态的方案数新加上到达i的方案数
        }
    }
}
```



##### 最小物品数

> 内层循环顺序不影响，但习惯先物品再背包



时间复杂度为O(n)，只能解决1e5

优化： 先算出base值dp,后面的再根据数学计算规律套公式

```c++
    for (int i:a) {
        for (int j=i;j<=n;j++) {
            dp[j]=min(dp[j],dp[j-i]+1);
        }
    }
```



##### 大数据

https://ac.nowcoder.com/acm/contest/120565/F

* 根据鸽笼原理，当n达到 lcm(2,7,8)时，更大的数，他一定是大量数据采用单价最优的策略（共3种策略）
* 在分别选这3种策略后，于是我们只需要分别进行枚举，其余俩的选取数量（0~10）内



### 分组背包

###### 最大价值

```c++
void solve() {
    int n,m;//物品数，包容量
    cin>>n>>m;
    vector<int>w(n+1),v(n+1),dp (n+1);
    vector<int> a(101);//记录每组的物品数量
    vector<vector<int> >num(101,vector<int>(n+1));//记录每件物品的组号，组中序，大序
    int x,t=0;//读入组号，记录组数
    for  (int i=1;i<=n;i++)  {
        cin>>w[i]>>v[i]>>x ;
        t=max(t,x);//刷新组数
        a[x]++;//组成员数
        num[x][a[x]]=i;//给组成员编号
    }
    
    for  (int i=1;i<=t;i++)  {//分组
        for  (int j=1;j<=m;j++)  {//背包
            for  (int k=1;k<=a[i];k++)  {//选择
                if  (j>=a[k]) dp[j]=max(dp[j],dp[j-w[num[i][k]]]+v[num[i][k]]);
            }
        }
    }
}
```



### 混合背包

[P1833 樱花 - 洛谷](https://www.luogu.com.cn/problem/P1833)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251211204829911.png" alt="image-20251211204829911" style="zoom:33%;" align="left"/>

```c++
    for (int i=1;i<=n;i++) {
        if (!a[i]) {
            for (int j=t[i];j<=st;j++) {//完全背包
                dp[j]=max(dp[j],dp[j-t[i]]+v[i]);
            }
        }else {
            for (int j=1;j<=a[i];j++) {//多次01背包
                for (int k=st;k>=t[i]*j;k--) {
                    dp[k]=max(dp[k],dp[k-t[i]]+v[i]);
                }
            }
        }
    }
```







# 线性DP

## 最长上升子序列

www.luogu.com.cn/problem/B3637

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251206151130778.png" alt="image-20251206151130778" style="zoom:33%;" align="left"/>



dp[i]记录以第i个结束的单增子序列长度， `dp[i]=max(d[i],d[j]+1)`

```c++
for (int i=1;i<=n;i++) {
        for (int j=1;j<i;j++) {
            if (a[j]<a[i]) dp[i]=max(dp[i],dp[j]+1);
        }
}
```



## 划分型DP

https://ac.nowcoder.com/acm/contest/120561/H

时间复杂度：O(n logn)



```c++
void solve() {
    int n;
    cin>>n;
    vector<i64> a(n+1);
    for (int i=1;i<=n;i++) {
        cin>>a[i];
    }

    int x=0;
    vector<int> pre(n+1);//优化复杂度：从O(n^2)到 O(n logn)
    pre[1]=0;
    for (int i=1;i<=n;i++) {
        pre[i]=x;
        if (a[i]) x=i;
    }

    vector<i64> dp(n+2),s(n+2);
    dp[1]=1,s[1]=1;//处理完前0个（即不处理）
    for (int i=1;i<=n;i++) {
        i64 y=0;
        int j=i;
        while (j&&(y&a[j])==0) {//只有不进位的才能 sum=or
            y|=a[j];
            j=pre[j];
        }

        //我们这里定义以i为结尾的最后一次划分，(j+1,i)
        //找到第一个非法点j ,则 dp[i+1]=dp[j+1]+...+dp[i]
        dp[i+1]=(s[i]-s[j]+mod)%mod;
        s[i+1]=(s[i]+dp[i+1])%mod;//前缀和优化
    }

    cout<<dp[n+1]<<'\n';
}
```





# 区间DP

### 区间合并1（中转站型）

> 这同时也是FLO的逻辑

[P1775 石子合并（弱化版） - 洛谷](https://www.luogu.com.cn/problem/P1775)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251208134331401.png" alt="image-20251208134331401" style="zoom:33%;" align="left"/>

> 贪心的堆那里也有一道类似的，但那是可以不相邻

```c++
    vector<vector<int>> dp(n+1,vector<int>(n+1,inf));
    for (int i=1;i<=n;i++) dp[i][i]=0;

    for (int len=2;len<=n;len++) {//长度
        for (int i=1;i+len-1<=n;i++) {//起点
            int j=i+len-1;
            for (int k=i;k<j;k++) {//中转点
                dp[i][j]=min(dp[i][j],dp[i][k]+dp[k+1][j]+pre[j]-pre[i-1]);
            }
        }
    }

    cout<<dp[1][n]<<'\n';
```



### 区间和并2

[F-竹摇清风拂面_牛客周赛 Round 124](https://ac.nowcoder.com/acm/contest/126120/F)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251229154524336.png" alt="image-20251229154524336" style="zoom:46%;" align="left"/>



遇到这种环形的题目，我们首先复制一份接在末尾，然后来一个长度为n的滑动窗口，

要满足不相交，我们可以抽象成区间，最多只能包含，不可相交，

那么怎么分开合并呢，**这里得考虑到区间的包含，不能只想中转站那样分离，因为可以跨越连接**

这时我们就将一个大区间分成两部分，枚举 l 跟谁连接，单独算这一对连接代价，然后加上它包含的区间的代价，及另一个区间的代价

```c++
    vector<vector<i64>> dp(2*n+2,vector<i64>(2*n+2,inf));
    for (int len=2;len<=n;len+=2) {
        for (int i=1;i+len-1<=2*n;i++) {
            int l=i,r=i+len-1;
            for (int k=l+1;k<=r;k++) {
                if (ss[l]!=ss[k]) continue;
                i64 L=0,R=0;

                if (l+1<=k-1) L=dp[l+1][k-1];//即便是空的区间（就那种起点>终点的）也要，因为待会可以进行l的相邻连接，或首尾连接
                if (k+1<=r) R=dp[k+1][r];
                if (L==inf||R==inf) continue;

                dp[l][r]=min(dp[l][r],L+R+a[l]*a[k]);
            }
        }
    }
```







### 好题

[Problem - C - Codeforces](https://codeforces.com/contest/2136/problem/C)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251218101819024.png" alt="image-20251218101819024" style="zoom:50%;" />

> （1）O(n)可以实现，经典的DP，主要是想不到贪心，然后你从n开始遍历，a[i]取不取其实跟你之前及当前的状态有关，
>
> （2）然后就是如何去设计DP，个数够了才考虑装，倒着装，每次装的不会超过a[i]个（因为超过的那些在前面早已决策好了）



```c++
void solve() {
    int n;
    cin>>n;
    vector<int> a(n+1),cnt(n+1);//用n记录c[i](即第i个位置)下的a[i]出现了多少次
    vector<vector<int>> pos(n+1);//存位置
    for (int i=1;i<=n;i++) {
        cin>>a[i];
        pos[a[i]].push_back(i);
        cnt[i]=pos[a[i]].size();
    }

    vector<int> dp(n+1);
    for (int i=1;i<=n;i++) {
        int x=cnt[i]-a[i];//我们得从后往前取a[i]
        if (x>=0) {
            int y=pos[a[i]][x]-1;//取位置的前一个
            dp[i]=dp[y]+a[i];
        }
        dp[i]=max(dp[i],dp[i-1]);
    }
    cout<<dp[n]<<'\n';
}

```





# 数位DP

* 求出在给定区间 [A,B] 内，符合条件  f(i)  的数的个数。条件一般与数的大小无关，而与数的组成有关
* 我们利用记忆化搜索 + 前缀和思想先求（1~B）再减去（1~A-1）



* 其实记忆化的过程就是我们数学分析的时候为避免重复运算而进行的简化操作，只不过数学分析直接由观察上公式，而记忆化则是在模拟这个过程，这也就是记忆化的正确性所在
* 将大问题分解为小问题，识别重复计算，通过缓存避免重复,而某几个小问题本质其实是一样的，因此我们可以通过记忆化来直接调用



## 杨辉三角版组合数

因为当不取模，且数字比较大的时候，用jc之类的组合数公式就有溢出的风险（得用__int128)，这时推荐数位DP

```c++
i64 cn[32][32];
void init() {
    for (int i=0;i<=31;i++) {
        cn[i][0]=1,cn[i][i]=1;
        for (int j=1;j<i;j++) {
            cn[i][j]=cn[i-1][j-1]+cn[i-1][j];
        }
    }
}
```



## 逆序对数列

[P2513 [HAOI2009\] 逆序对数列 - 洛谷](https://www.luogu.com.cn/problem/P2513)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20260113200957433.png" alt="image-20260113200957433" style="zoom:40%;" align="left"/>



* 对于1个全排列（含i-1个数），当我们已知他的逆序对数（j）时，那么对于全排列 i ,我们可以通过在原先的全排列(i-1) 上选择适当的位置插入我们的新数字i 从而在 i-1的基础上增加 x个逆序对 ，显然x的范围为：0~i-1,

  ```c++
  for(int i=2;i<=n;i++){
      for(int j=0;j<=k;j++){
          for(int l=max(0,j-(i-1));l<=j;l++){//哪些 i-1 排列可以做贡献
              dp[i][j] += dp[i-1][l];
              //对于该i-1 排列，他贡献l个 ，j的位置是唯一确定的，用来贡献 j-l个
              //i-1是插入新数可以新增贡献的，要想达到j,那么i-1排列得有个下限
          }
      }
  }
  ```



* 这个做法 O(nk^2)

考虑前缀和优化dp



```c++
//时间复杂度 ： O(nk)    
	vector<vector<int>> dp(n+1,vector<int>(n+1));
    dp[1][0]=1;
    for (int i=2;i<=n;i++) {
        int sum=0;
        for (int j=0;j<=k;j++) {
            sum=(sum+dp[i-1][j])%mod;
            dp[i][j]=sum;
            if (j>=i-1) sum=(sum-dp[i-1][j-(i-1)]+mod)%mod;
            //一段长度为i的区间，0~i-1
            //起初并不是i的长度，随着j++,才是，那我们就得减去左端的了
        }
    }
```



## ！位运算基本功

```c++
(s>>d)&1 // 判断d是否在s里
s | (1<<d) // 把d加进在s里
s & (~(1<<d)) //把d从s里清除
s ^ (1<<d) //有就去除，没就添加    
```



## 模板

对于DP,时间复杂度= 状态个数*转移个数 

[2376. 统计特殊整数 - 力扣（LeetCode）](https://leetcode.cn/problems/count-special-integers/description/)

```c++
//返回从i开始填的数字，i前面填的数字的集合是mask,能构造出特殊整数的数目
//is_limit 表示前面填的数字是否都是n对应位上的，true:当前位最多为s[i],false:最多位9
//is_num 表示前面是否填了数字（是否跳过）, true:那么当前位可以从0开始，false:那我们可以跳过，或从1开始   填数字

//时间复杂度：O(len(s))= O(log(n)),  O(log(n))*(1024)*(10)

    int n;
    cin>>n;
    string s=to_string (n);
    int m=s.length();
    vector<vector<int>> dp(m,vector<int>(1<<m,-1));

    //mask依据题意修改
    auto dfs=[&](auto &&dfs,int pos,int mask,bool islimit,bool isnum)->int {
        if (pos==m) return isnum;
        if (!islimit&&isnum&&dp[pos][mask]!=-1) return dp[pos][mask];

        int res=0;
        if (!isnum) res=dfs(dfs,pos+1,0,false,false);//选择跳过

        int up=islimit? s[pos]-'0':9;
        // 如果前面没有填数字，则必须从 1 开始（因为不能有前导零）
        for (int i=isnum ? 0:1;i<=up;i++) {
            if ((mask>>i&1)==0) {
                res+=dfs(dfs,pos+1,mask|(1<<i),islimit&&i==up,true);
            }
        }

        if (!islimit&&isnum) dp[pos][mask]=res;
        //因为不会再重复访问使用is_limit和!is_num的情况
        return res;

    };
```



时间复杂度：O(mD(2 ^D) )，其中 m 为 s 的长度，即 O(logn)，D=10。由于每个状态只会计算一次，因此动态规划的时间复杂度 = 状态个数 × 单个状态的计算时间。本题状态个数为 O(m(2 ^D) )，单个状态的计算时间为 O(D)，因此时间复杂度为 O(mD(2 ^D) )。
空间复杂度：O(m(2 ^D) )。



[P2602 [ZJOI2010\] 数字计数 - 洛谷](https://www.luogu.com.cn/problem/P2602)

[P4999 烦人的数学作业 - 洛谷](https://www.luogu.com.cn/problem/P4999)

* 这题我们在 dfs里面应该把 mask 换成sum ，（并加上tp,表示对应得数字）,并且在填完数的时候返回sum而不是isnum,因为上题是统计数字个数，而这题是统计数字出现次数，我们找到一个合法数时，应返回tp 在该数的出现次数即sum,而非1





# 状压DP

所谓状压，就是把一个状态表示成一个集合，再把集合表示成二进制数

状态 ---> 集合 --->  二进制数

> 先去看数位DP的位运算基本功



## TSP问题

TSP 是一个典型的 **NP-Hard（非确定性多项式困难）** 问题。

- 如果只有 3 个城市，路径很简单。

- 如果有 N 个城市，可能的路径总数是 (N-1)! / 2。

- 当 N=20 时，路径总数约为 6*1e16。

- 当 N=60 时，路径总数已经超过了宇宙中原子的总数。

  这意味着目前没有已知的算法能在“多项式时间”内找到所有情况下的最优解。



https://www.luogu.com.cn/problem/P1171

```c++
void solve() {
    int n;
    cin>>n;
    vector<vector<int>> mp(n+1,vector<int>(n+1));
    for (int i=1;i<=n;i++) {
        for (int j=1;j<=n;j++) {
            cin>>mp[i][j];
        }
    }

    vector<vector<i64>> dp(1<<n,vector<i64>(n+1,inf));
    dp[1][1]=0;//状态（走了哪些），现在在哪里
    
    for (int i=1;i<=(1<<n)-1;i++) {//先枚举状态
        for (int j=1;j<=n;j++) {//再企图更新，枚举当前点
            if (((i>>(j-1))&1)==0) {//没有来过，可以更新
                for (int k=1;k<=n;k++) {//利用Floyd思想，借用中转站更新
                    if ((i>>(k-1))&1) {
                        dp[i|(1<<(j-1))][j]=min(dp[i|(1<<(j-1))][j],dp[i][k]+mp[k][j]);
                    }
                }
            }
        }
    }

    i64 ans=inf;//别忘了最后还要回去
    for (int i=2;i<=n;i++) ans=min(ans,dp[(1<<n)-1][i]+mp[i][1]);
    cout<<ans<<'\n';

}
```





## 互不侵犯

https://www.luogu.com.cn/problem/P1896

> 在 N×N 的棋盘里面放 K 个国王，使在 N×N 的棋盘里面放 K 个国王，使他们互不攻击，共有多少种摆放方案。国王能攻击到它上下左右，以及左上左下右上右下八个方向上附近的各一个格子，共 8 个格子。他们互不攻击，共有多少种摆放方案。国王能攻击到它上下左右，以及左上左下右上右下八个方向上附近的各一个格子，共 8 个格子。

> 对于全部数据，1≤N≤9，0≤K≤N×N。



* 用01表示是否放置国王，s1,s2分别表示该行，上一行状态

* 行内合法：(( (s1<<1)|(s1>>1)) &s1)==0 ,我们可以先预处理得到所有的行内合法状态
* 行间合法：((s1|(s1<<1)|(s1>>1))&s2)==0

```c++
void solve() {
    int n,k;
    cin>>n>>k;
    vector<int> cnt(1<<n),ok;
    //预处理行内合法
    for (int i=0;i<(1<<n);i++) {
        int s=i,tot=0;
        while (s) {
            if (s&1) tot++;
            s>>=1;
        }
        cnt[i]=tot;
        if ((((i<<1)|(i>>1))&i)==0) ok.push_back(i);
    }

    vector<vector<vector<i64>>> dp(n+1,vector<vector<i64>>(k+1,vector<i64>(1<<n)));
    dp[0][0][0]=1; //第几行，共放了几个king, 该行状态
    for (int i=1;i<=n;i++) {
        for (int s1:ok) {//当前行
            for (int s2:ok) {//上一行
                if (((s1|(s1<<1)|(s1>>1))&s2)==0) {
                    for (int j=cnt[s1];j<=k;j++) {//这里有点像背包dp
                        dp[i][j][s1]+=dp[i-1][j-cnt[s1]][s2];
                    }
                }
            }
        }
    }

    i64 ans=0;
    for (int i:ok) ans+=dp[n][k][i];
    cout<<ans<<'\n';

}
```





# 优化

## 前缀和优化

* 累加和的dp方程可以考虑前缀和优化

[P2513 [HAOI2009\] 逆序对数列 - 洛谷](https://www.luogu.com.cn/problem/P2513)





## 单调队列优化

### 滑动窗口

https://www.zhihu.com/search?type=content&q=%E5%8D%95%E8%B0%83%E9%98%9F%E5%88%97

https://www.luogu.com.cn/problem/P2034

```c++
void solve() {
    int n,k;
    cin>>n>>k;

    deque<node> dq;
    vector<i64> dp(n+1);
    i64 sum=0;

    for (int i=1;i<=n;i++) {
        i64 x;
        cin>>x;
        sum+=x;

        if (i<=k+1) {
            dp[i]=x;
        }else {
            dp[i]=x+dq.front().tp;
        }

        p.tp=dp[i],p.id=i;

        while (!dq.empty()&&dq.back().tp>dp[i]) dq.pop_back();
        dq.push_back(p);
        while (!dq.empty()&&dq.front().id<=i-k-1) dq.pop_front();

    }

    i64 res=inf1;
    for (int i=n-k;i<=n;i++) {
        res=min(res,dp[i]);
    }
    
    cout<<sum-res<<'\n';

}
```







# 递推

## 台阶问题

https://www.luogu.com.cn/problem/P1192

```c++
dp[0]=1,dp[1]=1;
for (int i=2;i<=n;i++) {
    for (int j=1;j<=k;j++) {
        if (j<=i) {
            dp[i]=(dp[i]+dp[i-j])%mod;
        }
    }
}
cout<<dp[n]%mod;
```



https://www.luogu.com.cn/problem/P1077

由上一状态推出

```c++
vector<vector<int>> dp(n+1,vector<int> (m+1));
for (int i=0;i<=n;i++) dp[i][0]=1;

for (int i=1;i<=n;i++) {//第几种
    for (int j=0;j<=a[i];j++) {//这种摆多少
        for (int k=0;j+k<=m;k++) {//前面摆了多少
            if (!j&&!k) continue;
            dp[i][j+k]=(dp[i][j+k]+dp[i-1][k])%P;
        }
    }
}

cout<<dp[n][m]<<'\n';
```







## 其他

[E-Balanced 01-String_牛客周赛 Round 127](https://ac.nowcoder.com/acm/contest/126798/E)

经典好题

法1：

一共有 n-1 对 ，相等对= (n-1)  -  不等对  ，

* 不等对用异或计算（贡献值）即：求和 s[i]^s[i+1] ，那相等对的奇偶只与(n-1),不等对的奇偶有关
  * 于是我们求不等对的奇偶：由上式可推出即为全体的异或和 a[1]^a[2]^a[2]^a[3]^a[3]^a[4]^...^a[n]=a[1]^a[n]
  * 则相等的：(abs((n-1)%2-(a[1]^a[n])%2))%2;
  * 因此能否成，只与a[1],a[n]有关，而ans由 ? 的数目决定

```c++
    string s;
    cin>>s;
    i64 n=s.size();
    s='0'+s;
    i64 cnt=0;
    for (int i=2;i<n;i++) {
        if (s[i]=='?') cnt++;
    }
 
    i64 ans=0;
    if (s[1]!='?'&&s[n]!='?') {
        int x=s[1]-'0',y=s[n]-'0';
        int tp=(abs((n-1)%2-(x^y)%2))%2;
        if (tp) ans=0;
        else ans=qpow(2,cnt);
    }else if (s[1]=='?'&&s[n]=='?') {
        ans=qpow(2,cnt+1);
    }else ans=qpow(2,cnt);//由于数目大，且要取模，则用快速幂
```



法2：

DP

f [ i ] [ 相等对的奇偶性 ] [ 该位置的值0/1 ]  ，然后注意到f只跟前一位有关，于是可以滚动数组优化内存

```c++
    string s;
    cin>>s;

    int n=s.size();
    s='0'+s;

    vector<vector<int>> f(2,vector<int>(2));
    if (s[1]=='?') {
        f[0][0]=1;
        f[0][1]=1;
    }else if (s[1]=='1') f[0][1]=1;
    else f[0][0]=1;

    for (int i=2;i<=n;i++) {
        vector<vector<int>> g(2,vector<int>(2));

        if (s[i]!='1') {
            g[0][0]=f[0][1]+f[1][0];
            g[1][0]=f[1][1]+f[0][0];
        }

        if (s[i]!='0') {
            g[0][1]=f[0][0]+f[1][1];
            g[1][1]=f[0][1]+f[1][0];
        }

        for (int j=0;j<2;j++) {
            for (int k=0;k<2;k++) {
                g[j][k]%=mod;
            }
        }

        f=g;
    }

    cout<<(f[0][1]+f[1][0])%mod<<'\n';
```



# 二维DP

https://codeforces.com/contest/2173/problem/B

> 这里维护两个量mn[i],mx[i],
>
> mn[i]=min(mn[i-1]-a[i],b[i]-mx[i-1]
>
> mx[i]=max(mx[i-1]-a[i],b[i]-mn[i-1])
>
> 真的，我们推出当前状态下的max其实就需要借助上一步骤的两个量，mn[i-1],mx[i-1]
>
> 



# 三维DP

## 记忆化搜索

https://www.luogu.com.cn/problem/P1544

```c++
void solve() {
    int n,k;
    cin>>n>>k;
    vector<vector<i64>> a(n+1,vector<i64>(n+1));
    for (int i=1;i<=n;i++) {
        for (int j=1;j<=i;j++) {
            cin>>a[i][j];
        }
    }

    vector<vector<vector<i64>>> dp(n+1,vector<vector<i64>>(n+1,vector<i64>(k+1)));
    for (int i=1;i<=n;i++) {
        for (int j=0;j<=n;j++) {
            for (int l=0;l<=k;l++) {
                dp[i][j][l]=-1ll*inf*3;
            }
        }
    }

    for (int i=1;i<=n;i++) {
        for (int j=1;j<=i;j++) {
            for (int l=0;l<=min(i,k);l++) {
                dp[i][j][l]=max(dp[i-1][j][l],dp[i-1][j-1][l])+a[i][j];
                if (l) dp[i][j][l]=max(dp[i][j][l],max(dp[i-1][j][l-1],dp[i-1][j-1][l-1])+3ll*a[i][j]);
                //看3倍给谁，自己还是前者
            }
        }
    }

    i64 ans=-3ll*inf;
    k=min(n,k);
    for (int j=1;j<=n;j++) {
        for (int l=0;l<=k;l++) {
            ans=max(ans,dp[n][j][l]);
        }
    }

    cout<<ans<<'\n';
}
```



## 三段(好题)

https://atcoder.jp/contests/abc438/tasks/abc438_d

```c++
    vector<vector<i64>> dp(4,vector<i64>(n+1));
    for (int i=1;i<=n;i++) {
        dp[1][i]=dp[1][i-1]+a[1][i];
        if (i>=2) {
            dp[2][i]=max(dp[2][i-1],dp[1][i-1])+a[2][i];
            if (i>=3) {
                dp[3][i]=max(dp[3][i-1],dp[2][i-1])+a[3][i];
            }
        }
    }
```





# 其他

https://codeforces.com/contest/2193/problem/E

* 这种因数的题可以将数字拆解，考虑DP
* 先初始化dp[a[i]]=1,  再  dp[i]=min(dp[i],dp[j]+dp[j/i]);















