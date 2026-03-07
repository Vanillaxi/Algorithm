[TOC]

# 前言

不好划分/懒得划分



# 前缀后缀

[Problem - D - Codeforces](https://codeforces.com/contest/2171/problem/D)



# 贪心

## 贪心匹配

[Problem - E - Codeforces](https://codeforces.com/contest/2179/problem/E)



## 贪心构造

[Problem - D - Codeforces](https://codeforces.com/contest/2178/problem/D) 

* 就是排序后，根据游戏攻击策略进行贪心构造



## 断点

[Problem - 1555C - Codeforces](https://codeforces.com/problemset/problem/1555/C)

断点枚举，然后利用pre,suf,得到ans



## 01的连续

https://codeforces.com/group/PWkcuyLkT8/contest/668660/problem/A

* 对于每一个颜色 i , 可以简化成01串，1的是已经为i色的，先令ans[i]=w[i]+n, 然后O(n)遍历c, 用cnt记录1，当cnt>w[c[i]]时， ans[c[i]]--,开始时要先处理好边界，l->c[1] , r-> c[n],

  ```c++
      int l=n+1,r=n;
      for (int i=1;i<=n;i++) {
          if (c[i]==c[1]) ans[c[1]]--;
          else {
              l=i;
              break;
          }
      }
  
      for (int i=n;i>=l;i--) {
          if (c[i]==c[n]) ans[c[n]]--;
          else {
              r=i;
              break;
          }
      }
  
      if (l==n+1) ans[c[1]]=0;
      int cnt=1;
      for (int i=l;i<=r;i++) {
          if (c[i]==c[i-1]) cnt++;
          else cnt=1;
  
          if (cnt>w[c[i]]) ans[c[i]]--;
      }
  
  ```

  

# 背包

## 01背包

[D - Robot Customize](https://atcoder.jp/contests/abc431/tasks/abc431_d)



# 滑动窗口

[C - Truck Driver](https://atcoder.jp/contests/abc430/tasks/abc430_c)  双指针



[D-小月的前缀_牛客练习赛147](https://ac.nowcoder.com/acm/contest/125084/D)

* trick: 为了方便移动，我们直接把整个a复制一边到后面去

1  -2  3  -1  2  ， 1  -2  3  -1  2

* 接下来枚举断点，在断点往后的一个长度为n的滑动窗口中查看相应前缀和的值是否大于0，对于每一部分真实的前缀和 npre[i]=pre[i]-pre[r];(r是你移动多少个),求他>0的个数

然后就是  pre[i]>pre[r] 的数量 

用权值树状数组维护即可



## 先分组

[C - Striped Horse](https://atcoder.jp/contests/abc440/tasks/abc440_c)

* 读懂题意后，发现这其实就是一个定长滑动窗口，最前面可以补若干个0，然后取w个，后面w个不取，一直滑动下去，那你怎么选位置呢
* 这里有O(n+w)的做法，先把下标按(i%(2w))分组和，在搞一个循环数组，取个pre,然后滑下去，取长度为w的min即可



# 数学

[魔法棒_牛客题霸_牛客网](https://www.nowcoder.com/practice/976bd95dda8f4430b512d0c39bd9f106?channelPut=tracker2)

* 根据连续覆盖，且最小增量是3，只需找到3个连续的合法数即可，枚举



[E-小红做梦_牛客小白月赛126](https://ac.nowcoder.com/acm/contest/125955/E)







## 组合数学

[Problem - D - Codeforces](https://codeforces.com/contest/2182/problem/D)

* 合法性判断，组合

[Problem - 478B - Codeforces](https://codeforces.com/problemset/problem/478/B)

* 组合的时候我们在连线，不就是图吗，依照这个可以辅助证明贪心



[D - Kadomatsu Subsequence](https://atcoder.jp/contests/abc439/tasks/abc439_d)

* 其实我们需要当前a[i]=5k前面及后面的7k,3k数量，相乘即可，因此我们可以用map维护，遍历完前面再把a给reverse进行相同操作



## gcd

[Problem - 1521B - Codeforces](https://codeforces.com/problemset/problem/1521/B)



# 数据结构

## 栈

[C - 1D puyopuyo](https://atcoder.jp/contests/abc438/tasks/abc438_c)

* 要删除，但无关删除的顺序，我们就是想找到一个支持查询（边进去边查）和删除的数据结构



[C - Brackets Stack Query](https://atcoder.jp/contests/abc428/tasks/abc428_c)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251231204005531.png" alt="image-20251231204005531" style="zoom:50%;" align="left"/>



* 括号合法，考虑栈，但如何处理删除呢，这意味着我们要查询上一状态，于是一旦匹配就-1，否则+1
* 但是当某个时候的  )  多余  （  那后面就都不合法了，于是我们需要用b 记录



```c++
    stack<int> a,b;
    a.push(0),b.push(0);
    while (n--) {
        int x;
        char c;
        cin>>x;
        if (x==1) {
            cin>>c;
            a.push(a.top()+(c=='('?1:-1));
            b.push(min(a.top(),b.top()));
        }else {
            a.pop();
            b.pop();
        }
        if (!a.top()&&!b.top()) cout<<"YES\n";
        else cout<<"NO\n";
    }
```



## 排序

### 序列合并

https://www.luogu.com.cn/problem/P1631

2个序列，各抽2个数，有n^2种选法，求前n小的数，

* 先分别sort，再打个表，然后我们把a[1]+b[i],a[2]+b[i],...a[n]+b[i] 看作n个队列
* 先把各序列的第一个进队，然后每pop一个，我们就补上该元素所在序列的后面一个元素



# LIS

## 一维

[B3637 最长上升子序列 - 洛谷](https://www.luogu.com.cn/problem/B3637)

[H - LIS](https://atcoder.jp/contests/chokudai_S001/tasks/chokudai_S001_h)

也类似于下面的做法，dp只能在小数据时用



## 二维

只要识别出二维偏序

[E - Kite](https://atcoder.jp/contests/abc439/tasks/abc439_e)

* 组间升序，组内降序，val中升序，才能lowerr_bound

```c++
void solve() {
    int n;
    cin>>n;

    vector<array<int,2>> a(n);
    for (int i=0;i<n;i++) {
        cin>>a[i][0]>>a[i][1];
    }

    sort(a.begin(),a.end(),[](auto &x,auto &y) {
        if (x[0]!=y[0]) return x[0]<y[0];//组内降序
        return x[1]>y[1];//组间升序
    });

    vector<int> val;//其实val记录的并非真实的lis，其中包含了一些后续的更新
    for (int i=0;i<n;i++) {
        if (val.empty()||a[i][1]>val.back()) val.push_back(a[i][1]);//增长序列
        else *lower_bound(val.begin(),val.end(),a[i][1])=a[i][1];//修改，为后续增长序列创造机会
    }
    cout<<val.size()<<'\n';
}
```



## 偏序+DAG拓扑

https://codeforces.com/contest/2195/problem/F

* 首先把结构体排序,统一方向 `a.a<b.a;` 
* `a.a<b.a&&(a.b-b.b)*(a.b-b.b)-4*(a.a-b.a)*(a.c-b.c)<0;`这是排序后的子集条件
* 然后就是像lis一样求最长序列,其实这就是拓扑排序,关键是得会将 check写出来

```c++
struct func {
    i64 a,b,c;
    int id;

    friend bool operator< (func a,func b) {
        if (a.a!=b.a) return a.a<b.a;
        return a.c<b.c;
    }
};

bool check(func a,func b) {
    if (a.a==b.a) {//直线
        if (a.b==b.b&&a.c<b.c) return true;
        return false;
    }

    return a.a<b.a&&(a.b-b.b)*(a.b-b.b)-4*(a.a-b.a)*(a.c-b.c)<0;
}

void solve() {
    int n;
    cin>>n;
    vector<func> f(n+1);
    for (int i=1;i<=n;i++) {
        cin>>f[i].a>>f[i].b>>f[i].c;
        f[i].id=i;
    }

    sort(f.begin()+1,f.end());
    vector<int> pre(n+1,1),suf(n+1,1),ans(n+1);
    for (int i=1;i<=n;i++) {//前面
        for (int j=1;j<i;j++) {
            if (check(f[j],f[i])) {
                pre[i]=max(pre[i],pre[j]+1);
            }
        }
    }

    for (int i=n;i>=1;i--) {//后面
        for (int j=i+1;j<=n;j++) {
            if (check(f[i],f[j])) {
                suf[i]=max(suf[i],suf[j]+1);
            }
        }
    }

    for (int i=1;i<=n;i++) {
        ans[f[i].id]=pre[i]+suf[i]-1;
    }

    for (int i=1;i<=n;i++) {
        cout<<ans[i]<<" \n"[i==n];
    }
}
```



# 暴力

[A-「SFCOI-4」剑客花木兰_牛客挑战赛85](https://ac.nowcoder.com/acm/contest/126635/A)

为了防止tle，我们在枚举时还需要注意到cnta<b，因为如果cnta>=b,那么这一部分 `a*cnta` 完全可以用b来代替b*cntb,必定会更优，这启发了我们要注意因子，乘积

还有就是枚举cnta 的时候最好正着枚，不易出错，不然可能卡在了某个数据弄出他是负的，但没有限制掉





# 位（十进制）

[E-小红的完全平方数构造_牛客周赛 Round 126](https://ac.nowcoder.com/acm/contest/126636/E)

* 其实我们只需要枚后面填多少个位，res*=10，cnt*=10,  然后我们想要的就是大于这个数但又小于临界值的，

  ```c++
      i64 res=n*10,cnt=10;
      while (true) {
          i64 x=sqrt(res)+1;
          if (x*x-res<cnt) {
              cout<<x*x<<'\n';
              return;
          }
  
          res*=10;
          cnt*=10;
      }
  ```

  



# 二分

## 找第k大

[D - Forbidden List 2](https://atcoder.jp/contests/abc440/tasks/abc440_d)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20260111110816170.png" alt="image-20260111110816170" style="zoom:50%;" align="left"/>



先给a添加哨兵，a[0]=-inf, a[n+1]=inf;

我们记  `i64 tp=lower_bound(a.begin()+1,a.end(),x)-a.begin();`

对于a[mid],  a[mid]到x的元素 ：a[mid]-1+1 ,  在a中 ：mid-tp+1 ,那么不在a中为二者相减，记为z;

二分，显然mid越大，z越大，

`i64 ans=(x+y-1)+(res-tp);`//记住这里ans是取不到a[res]的，不在a中嘛，所以得把他去掉，也就是 不用+1



## 记录

[Problem - E - Codeforces](https://codeforces.com/contest/2185/problem/E)

* 先开两个数组pl,pr表示每一步的向左向右走的区间的并集（就是走多远），记得得和前面的比较取max,
* 然后二分,查找每个机器人阵亡的上一个位置，该位置pos,  ans[pos]++， 再来搞个后缀和即可
* check:  机器人合法活动范围是左右两个尖刺之间，查找（1~q）那时候的，pl[x]>=dl,  pr[x]>=dr, 为非法，

dl,dr是初始位置到两端的距离



```c++
    vector<int> pl(q+5),pr(q+5);
    int c=0;
    for (int i=1;i<=q;i++) { //并区间，就是必走过的
        if (s[i]=='L') c--;
        else c++;

        pl[i]=max(pl[i-1],-c);
        pr[i]=max(pr[i-1],c);
    }

    auto check=[&](int k,int dl,int dr)->int {
        int ll=0,rr=k+1,res;
        while (ll<=rr) {
            int mid=(ll+rr)/2;
            if (pl[mid]>=dl||pr[mid]>=dr) rr=mid-1;//非法
            else {
                ll=mid+1;
                res=mid;
            }
        }
        return res;
    };

    vector<int> ans(q+2);
    int l,r;
    for (int i=1;i<=n;i++) {
        //找右界
        int x=upper_bound(b.begin()+1,b.end(),a[i])-b.begin();
        if (x>m) r=inf;
        else r=b[x]-a[i];

        //找左界
        x--;
        if (x<1) l=inf;
        else l=a[i]-b[x];

        ans[check(q,l,r)]++;
    }

    for (int i=q;i>=1;i--) ans[i]+=ans[i+1];
    for (int i=1;i<=q;i++) cout<<ans[i]<<" \n"[i==q];
```





# 双指针

https://codeforces.com/contest/2193/problem/D

* 这题不是三分，因为点离散，阶梯式，并不平滑

* x增大，cnt关卡就会减小，并且x只有取a[i]其实才有参考价值，那么我们就来双指针，因为x减小的时候，他能过的关卡肯定大于等于x更大时候的

  *  x      小 <----- 大

    pre   小 -----> 大



# 期望

## 图论

https://ac.nowcoder.com/acm/contest/127264/F

图上dfs

只有走回头路才能清算  cnt  ,  我们直接用  ans+= dep*p

```c++
    vector<int> dep(n+1);
    auto dfs=[&](auto &&self,int u,int f,i64 p)->void {//p是走到该节点的概率
        dep[u]=dep[f]+1;
        p=p*inv(adj[u].size())%P;

        for (int v:adj[u]) {
            if (v==f) ans=(ans+dep[u]*p%P)%P;
            else self(self,v,u,p);
        }
    };

    dfs(dfs,1,1,1);
```

