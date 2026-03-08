# 数学与计算

[TOC]



# 数论

## 素数筛

### 欧拉筛

> 贡献思想



```c++
vector<int> minp,primes;
void sieve(int n) {
    minp.assign(n+1,0);
    primes.clear();
    for (int i=2;i<=n;i++) {
        if (!minp[i]) {
            minp[i]=i;
            primes.push_back(i);
        }

        for (auto p:minp) {
            if (i*p>n) break;
            minp[i*p]=p;
            if (minp[i]==p) break;
        }
    }
}
```



### 区间筛

在欧拉筛的基础上加上这一段



#### 单次查询

（l,r特别大，mle时选）

```c++
void solve() {
    int l,r;
    cin>>l>>r;

    vector<int> vis(r-l+1);

    for (auto p:primes) {
        if (p*p>r) break;
        i64 hi=max((i64) p*p,(i64) ((l+p-1)/p)*p);
        //保证从p贡献的第一个合数算起，> l的最小p的倍数，如3从9开始
        for (i64 j=hi;j<=r;j+=p) {
            if (j==p) continue;
            vis[j-l]=1;//注意这里是在映射
        }
    }

    if (l==1) vis[0]=1;//非质数打标记
    int ans=0;
    for (int i=0;i<=r-l;i++) {
        if (!vis[i]) ans++;
    }
    cout<<ans<<'\n';
}
```



#### 多次查询

用前缀和





### 例题

#### 典型的质因数分解+排列组合

[F-除数链_2025年华南理工大学程序设计竞赛（秋季赛）](https://ac.nowcoder.com/acm/contest/121614/F)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251207004536825.png" alt="image-20251207004536825" style="zoom:33%;" align="left"/>



```c++
constexpr int mxn=2e6;
//改成这个mxn是因为n:1e12，我们只需检测到1e6即可

vector<int> minp(mxn+1),primes;
vector<i64> jc(mxn+2);

void sieve(int n) {
    minp[1]=1;
    for (int i=2;i<=n;i++) {
        if (!minp[i]) {
            minp[i]=i;
            primes.emplace_back(i);
        }
        for (auto p:primes) {
            if (i*p>n) break;
            minp[i*p]=p;
            if (minp[i]==p) break;
        }
    }
}

i64 qpow(i64 a,int b) {
    i64 ans=1,tp=a;
    while (b) {
        if (b&1) {
            ans=(ans*tp)%P;
        }
        tp=(tp*tp)%P;
        b>>=1;
    }
    return ans;
}

void init(i64 n) {
    jc[0]=jc[1]=1;
    for (i64 i=2;i<=n;i++) {
        jc[i]=jc[i-1]*i%P;
    }
}

void solve() {
    i64 n;
    cin>>n;
    i64 cnt=0;
    map<i64,i64> mp;
    for (auto p:primes) {
        while (n%p==0) {
            mp[p]++;
            n/=p;
            cnt++;
        }
    }
    if (n>1) cnt++,mp[n]++;//它本身就是一个超级无敌大的prime，这数据。。。。。。

    i64 ans=1;
    for (auto [u,v]:mp) {
        ans=ans*jc[v]%P;
    }

    cout<<cnt+1<<" "<<jc[cnt]*qpow(ans,P-2)%P<<'\n';
}
```



## 例题

### 双指针

> 伊哈卜喜欢数论，但由于某种原因，他讨厌数字。给定一个数组a,求出它的最长子数组的长度，使得其元素的和不能被z整除，或者确定这样的子数组不存在。
>
> 数组a是数组b的子数组，如果a可以从b中通过删除开头的几个(可能为零或全部)元素和末尾的几个(可能为零或全部)元素来获得。



`if(sum%x!=0) ans=n;`
`else` 若每个`a[i]%x==0,ans=-1`
`else` 用l,r分别记录两端第一个不能被x整除的pos,删掉较小的那个即可



### 与循环有关

> 假设你和两只猫住在一起：A和B。有两只猫通常睡觉的小憩点。你的猫喜欢睡觉，也喜欢所有这些点，所以它们每小时循环地改变一个午睡点：
>
> -猫A按顺序改变它打盹的位置：n,n-1,n-2,….,3,2,1,n,n-1,….换句话说，在第一个小时它在原地n,然后依次递减；
>
> -猫B按顺序改变它的午睡位置：1,2,3,…,n-1,n,1,2,….换句话说，在第一个小时，它在现场1,然后循环递增顺序。
>
> 猫B要小得多，所以它们有严格的等级制度：a和B不会躺在一起。换句话说，如果两只猫都想去位置x,那么A就会去这个位置，
>
> 计算一下，猫B在小时k的位置?B就会按照它的顺序移动到下一个位置(如果x<n,那么就去z+1,但如果z=n,那么就去1)。猫B遵循他的顺序，所以在A释放它之后，它不会回到被跳过的位置z,而是会移动到位置c+2,以此类推。



注意到n是偶数无影响，关键在于奇数，先k--,走n/2步二者反向，B会多走1步，此时的情况等价于初始情况，我们只需计算B走了多少步,再%n,然后+1即可
`ans=（k+(n&1)*k/(n/2))%n+1`





## 同余方程

[Problem - 2134B - Codeforces](https://codeforces.com/problemset/problem/2134/B)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251208200426787.png" alt="image-20251208200426787" style="zoom:50%;" />

> 令gcd=k+1;
>
> (a[i]+x*k)%(k+1)==0;
>
> `a[i]+x*k≡x+x*k≡0 (mod k+1)`
>
> 令x=a[i]%(k+1); (因为x<=k)



## 裴蜀定理&不定方程

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251217142525995.png" alt="image-20251217142525995" style="zoom:50%;" />

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251217142550466.png" alt="image-20251217142550466" style="zoom:50%;" />





[P4549 【模板】裴蜀定理 - 洛谷](https://www.luogu.com.cn/problem/P4549)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251217142721556.png" alt="image-20251217142721556" style="zoom: 33%;" align="left"/>

> 其实这道题就是求gcd



## 欧几里得定理

定理： gcd (a,b) = gcd (a,b%a);



## exgcd

https://www.luogu.com.cn/problem/P5656

> 给定不定方程  ：  ax+by=c
>
> 若该方程无整数解，输出 −1。
> 若该方程有整数解，且有正整数解，则输出其**正整数**解的数量，所有**正整数**解中 *x* 的最小值，所有**正整数**解中 *y* 的最小值，所有**正整数**解中 *x* 的最大值，以及所有**正整数**解中 *y* 的最大值。
> 若方程有整数解，但没有正整数解，你需要输出所有**整数解**中 *x* 的最小正整数值， *y* 的最小正整数值。
>
> 正整数解即为 *x*,*y* 均为正整数的解，**0** **不是正整数**。
>
> 整数解即为 *x*,*y* 均为整数的解。
> *x* 的最小正整数值即所有 *x* 为正整数的整数解中 *x* 的最小值，*y* 同理。

求一组时间复杂度： O(log n)

```c++
    i64 a,b,c;
    cin>>a>>b>>c;
    i64 x=0,y=0;

    auto exgcd=[&](auto &&self,i64 ai, i64 bi)->i64 {//会改动x,y
        if (bi == 0) {
            x = 1, y = 0;
            return ai;
        }
        i64 d = self(self,bi, ai % bi), tmp = x;
        x = y, y = tmp - ai / bi * y;
        return d;
    };
//这里x,y将变为 ax+by=g的一组特解，g=gcd(a,b);
```



```c++
i64 exgcd(i64 a, i64 b, i64 &x, i64 &y) {
    if (b == 0) {
        x = 1, y = 0;
        return a;
    }
    i64 d = exgcd(b, a % b, x, y), tmp = x;
    x = y, y = tmp - a / b * y;
    return d;
}
```



* 通解公式：(x0,y0为特解)

  * x = x0+k*(b/g); // 所有特解在模b/g下都是同余

    y = y0 - k*(a/g);

  * 推导

    * 两个解的差必须让 ax+by 保持为 0
      这强制它们按 (b/g , -a/g) 方向移动
    * gcd(a/g , b/g) = 1，这是保证最小步长的关键
    * (x%m+m)%m,  而不是 x%m, 为了防止x<0, 负数%正数=负数

```c++
void solve() {
    i64 a,b,c;
    cin>>a>>b>>c;
    i64 x=0,y=0;
    
    auto exgcd=[&](auto &&self,i64 ai, i64 bi)->i64 {
        if (bi == 0) {
            x = 1, y = 0;
            return ai;
        }
        i64 d = self(self,bi, ai % bi), tmp = x;
        x = y, y = tmp - ai / bi * y;
        return d;
    };

    i64 g=exgcd(exgcd,a,b);
    if (c%g) {
        cout<<"-1\n";
        return;
    }

    x=x*(c/g),y=y*(c/g);
    i64 ansxmn=(x%(b/g)+b/g)%(b/g);//把特解 x 调整成模 (b/g) 意义下的最小非负代表
    i64 ansymn=(y%(a/g)+a/g)%(a/g);
    if (!ansxmn) ansxmn=b/g;
    if (!ansymn) ansymn=a/g;
    i64 ansxmx=(c-b*ansymn)/a;
    i64 ansymx=(c-a*ansxmn)/b;
    i64 t=(ansxmx-ansxmn)/(b/g);
    if (ansymx<=0&&ansxmx<=0) {
        cout<<ansxmn<<" "<<ansymn<<'\n';
    }else {
        cout<<t+1<<" "<<ansxmn<<" "<<ansymn<<" "<<ansxmx<<" "<<ansymx<<'\n';
    }
    
}
```



### 改良版

```c++
i128 exgcd(i128 a, i128 b, i128 &x, i128 &y) {
    if (b == 0) {
        x = 1, y = 0;
        return a;
    }
    i128 d = exgcd(b, a % b, x, y), tmp = x;
    x = y, y = tmp - a / b * y;
    return d;
}
 
//判断是否有解，并求出一组特解
bool liEu(i128 a, i128 b, i128 c, i128 &x, i128 &y, i128& g) {
    g = exgcd(a, b, x, y);
    if (c % g != 0) return false;
    i128 k = c / g;
    x *= k, y *= k;
    return true;
}
```



```c++
    a/=g,b/=g;
    i128 lo=udiv(-x0,b),hi=ddiv(y0,a);//这里其实是在给丢番图卡区间，保证x>=0,y>=0
    if (lo>hi) {
        puts("No\n");
        return;
    }
```



https://ac.nowcoder.com/acm/contest/120564/D

在所有解中，使得min(max(x,y));

其实就是 x=x0+t*(b/g) 与 y=y0- t*(a/g)的交点，x单增，y单减，分别令x=0,y=0,求出t的左右界

我们用 (y0-x0)/(a+b), 是因为我们这时看作x=y,但我们需要分别udiv,ddiv

```c++
i128 exgcd(i128 a, i128 b, i128 &x, i128 &y) {
    if (b == 0) {
        x = 1, y = 0;
        return a;
    }
    i128 d = exgcd(b, a % b, x, y), tmp = x;
    x = y, y = tmp - a / b * y;
    return d;
}

bool liEu(i128 a, i128 b, i128 c, i128 &x, i128 &y, i128& g) {
    g = exgcd(a, b, x, y);
    if (c % g != 0) return false;
    i128 k = c / g;
    x *= k, y *= k;
    return true;
}

i128 udiv(i128 a, i128 b) {
    if (a >= 0) return (a + b - 1) / b;
    return a / b;
}

i128 ddiv(i128 a, i128 b) {
    if (a >= 0) return a / b;
    return (a - b + 1) / b;
}

void solve() {
    i128 L=read(),a=read(),b=read();

    i128 x0,y0,g;
    if (!liEu(a,b,L,x0,y0,g)) {
        puts("No");//会自动换行
        return;
    }

    a/=g,b/=g;
    i128 lo=udiv(-x0,b),hi=ddiv(y0,a);
    if (lo>hi) {
        puts("No");
        return;
    }

    array<i128,3> ans={infll,infll,infll};

    i128 t1=udiv(y0-x0,a+b);//交点
    t1=clamp(t1,lo,hi);
    i128 x1=x0+b*t1,y1=y0-a*t1;
    ans=min(ans,{max(x1,y1),x1,y1});

    i128 t2=ddiv(y0-x0,a+b);
    t2=clamp(t2,lo,hi);
    i128 x2=x0+b*t2,y2=y0-a*t2;
    ans=min(ans,{max(x2,y2),x2,y2});

    puts("Yes");
    write(ans[1]);
    putchar(' ');
    write(ans[2]);
    putchar('\n');

}
```



# 位运算

> 按位分析思想



1. 对于a,b的每一位, (a&b)+(a^b)=(a|b)
2. 奇数&1=1 ,偶数&1=0
3. 若a^b=c,则a^c=b,a^b=c
4. (1) a^0=a
   (2) a^a=0
   (3) a^b=b^a
   (4) a^(b^c)=(a^b)^c
5. 善用异或，得出出现奇数次的数,也可在字符char上用
6. 小心   `1<<n  ,   1ll<<n`



## 例题

> 这是问题的困难版。简单版和困难版的唯一区别是，在困难版中，ai,bi≤10⁶。
> 给阿治赛和小麦长度为n(0≤a,b₃≤10⁶)的数组a和b。他们将下一盘持续n轮的棋，其中阿治赛在奇数轮移动，而小麦在偶数轮移动。在第i轮，下棋者可以选择交换a和b,或者弃着。
> 请注意，如果发生交换，被交换的索引必须与回合数一致。例如，在第一回合，阿吉赛可以选择交换a1和b1,或者弃权。在第二个回合，小麦可以选择交换a2和b2,或者弃权。这种情况会持续n个回合。因此，只有阿吉赛可以交换奇数索引，只有麦可以交换偶数索引。
> 对局结束时，阿字西得分为a1^a2^...^an,小麦得分为b1^b2^…^bn。得分较高的玩家获胜。如果双方得分相同，则游戏以平局结束。
> 确定最佳下法的游戏结果。更正式地说，如果有一种策略能让一名棋手无论对手如何选择都能获胜，那么这名棋手就被认为是以最优策略获胜的。如果双方都没有这样的策略，那么这盘棋就被认为是平局。



先全都异或到sum,若sum==0，则Tie,再看谁控制最高位，从n到1遍历，a[i]^b[i],



## 基本功能

```c++
(mask>>d)&1 // 检查d是否在mask里
mask|(1<<d) // 把d设置在mask里
mask &~(1<<d) //把d从mask里清除
```







# 模

1.难度较低的数论题一般都是根据代数式特质可轻松实现
（1）先写出代数式，其实不必担心写的时候涉及到一些丑陋的量，
（2）然后根据目标式子（一般为较简单的或为右式） ，将其余部分进行转化
（3）这里我们易写出  (kx+y)%y==0, (kx+(x+y))%(x+y)==0
（4）从需要什么因子和转化式必有什么因子分析题目一般要我们求y,我们只需令y=(k-1)x

2.一些好用的性质
(1)  (a+b) mod c=(a mod c+b mod c)mod c
(2)  (a*b) mod c=(a mod c* *b mod c)mod c

3.小心，（a%b),某些提题目简写+=又连上%的，如果结果有负数，就别简写，对负数 %规则与正数同，符号与a同

## 取模注意

（1）用i64,而不是u64

（2）不要+=,要全写

（3） 对于乘法的每个因子都要取模，然后再对整个乘积式取模，勤加括号勤取模

（4）ans=(ans-x+p)%p，负数的处理得会

（5）ans=(y+p-1)/p,向上取整，别与（4）混淆了

（6）取模后的两个数大小关系可能会变，因此有时候不能用max





## 小结论：

```c++
(x % P - y % P) % P = (x - y) % P;
(x % P + y % P) % P = (x + y) % P
    
(a % M - b) % M = (a - b) % M    
(a - b % M) % M = (a - b) % M

(a + xM) % M = a % M
```



```c++
void add(i64 &x,i64 y) {//防止负数
    x=((x+y)%P+P)%P;
}
```



## 好题

### 子数组和模P最大

https://ac.nowcoder.com/acm/contest/120565/E

时间复杂度：O(n log(n))

* 首先肯定要维护前缀和，根据模的性质，我们可以维护模前缀和
* O(n) 遍历时 , 对于当前位置，我们以当前位置结尾时，要想使mod和max，我们分别需要找前面的两个数
  * 考虑 x>sum: new= (sum-x+P)%P, 易知，x选min时最优
  * 考虑 x<sum: new=(sum-x)%P, 易知，x选min时最优
* 我们可以用map实现， 用三元组array

```c++
i64 P=1e9+7;

void add(i64 &x,i64 y) {
    x=((x+y)%P+P)%P;
}

void solve() {
    i64 n;
    cin>>n>>P;
    vector<int> a(n);
    for (int i=0;i<n;i++) cin>>a[i];

    i64 sum=0;
    map<i64,i64> mp;
    mp.insert({0,-1});//记录前缀和
    array<i64,3> ans={-inf,-1,-1};
    for (int i=0;i<n;i++) {
        add(sum,a[i]);
        auto it=mp.upper_bound(sum);
        if (it!=mp.end()) ans=max(ans,{(sum-it->first+P)%P,it->second+1,i});
        ans=max(ans,{(sum-mp.begin()->first+P)%P,mp.begin()->second+1,i});
        mp.insert({sum,i});
    }

    cout<<ans[1]<<" "<<ans[2]<<" "<<ans[0]<<'\n';
}
```





# 矩阵乘法

2个矩阵  n * m   ,   m * k  ,得到矩阵  n  *  k ,

* 使用 l -- i --  j  连续访问内存，更快

[B2105 矩阵乘法 - 洛谷](https://www.luogu.com.cn/problem/B2105)

```c++
void solve() {
    int n,m,k;
    cin>>n>>m>>k;
    vector<vector<i64>> a(n+1,vector<i64>(m+1));
    vector<vector<i64>> b(m+1,vector<i64>(k+1));
    vector<vector<i64>> c(n+1,vector<i64>(k+1));

    for (int i=1;i<=n;i++) {
        for (int j=1;j<=m;j++) {
            cin>>a[i][j];
        }
    }

    for (int i=1;i<=m;i++) {
        for (int j=1;j<=k;j++) {
            cin>>b[i][j];
        }
    }

    for (int l=1;l<=m;l++) {
        for (int i=1;i<=n;i++) {
            for (int j=1;j<=k;j++) {
                c[i][j]+=a[i][l]*b[l][j];
            }
        }
    }

    for (int i=1;i<=n;i++) {
        for (int j=1;j<=k;j++) {
            cout<<c[i][j]<<" \n"[j==k];
        }
    }
}
```



# 快速幂

对于那些要取模，且数比较大的，别忘了  1ll<<x  ,别用了，用快速幂

```c++
i64 qpow(i64 a,i64 b,i64 p)  {//求a的b次幂
    i64 ans=1,base=a;
    while  (b)  {
        if  (b&1)  {//可以理解成一次搞出二个
            ans=(ans*base)%p ;
        }
        base=(base*base)%p;
        b>>=1;
    }
    return ans;
}
```



# 矩阵快速幂

对一个 n*n 的 矩阵，求他的k次幂

* 单位矩阵（0阶）：主对角线为1，其他位置为0，单位矩阵*其他矩阵=其他矩阵

```c++
    i64 n,k;
    cin>>n>>k;

    vector<vector<i64>> a(n+1,vector<i64>(n+1));
    for (int i=1;i<=n;i++) {
        for (int j=1;j<=n;j++) {
            cin>>a[i][j];
        }
    }

//先初始化ans为单位矩阵，就像快速幂里的1
    vector<vector<i64>> ans(n+1,vector<i64>(n+1,0));
    for (int i=1;i<=n;i++) {
        ans[i][i]=1;
    }

//ans*a
    auto jc1=[&]()->void {
        vector<vector<i64>> b(n+1,vector<i64>(n+1,0));
        for (int l=1;l<=n;l++) {
            for (int i=1;i<=n;i++) {
                for (int j=1;j<=n;j++) {
                    b[i][j]=(b[i][j]+ans[i][l]*a[l][j]%mod)%mod;
                }
            }
        }

        for (int i=1;i<=n;i++) {
            for (int j=1;j<=n;j++) {
                ans[i][j]=b[i][j];
            }
        }
    };

//a*a
    auto jc2=[&]()->void {
        vector<vector<i64>> b(n+1,vector<i64>(n+1,0));
        for (int l=1;l<=n;l++) {
            for (int i=1;i<=n;i++) {
                for (int j=1;j<=n;j++) {
                    b[i][j]=(b[i][j]+a[i][l]*a[l][j]%mod)%mod;
                }
            }
        }

        for (int i=1;i<=n;i++) {
            for (int j=1;j<=n;j++) {
                a[i][j]=b[i][j];
            }
        }

    };

    while (k) {
        if (k&1) {
            jc1();
        }
        jc2();
        k>>=1;
    }
```





# 逆元

## 1.费马小定理

p是质数，在qpow的基础上加上这个

(n/m)%P=n*(m^(P-2));

```c++
void solve() {
    int n,p ;
    cin>>n>>p ;
    cout<<qpow(n,p-2,p)%p;
}
```



## 2.线性递推法

* 批量处理数据且数据连续时的首选

```c++
void solve() {
    int n,p ;
    cin>>n>>p ;
    vector<i64> inv(n+1,1) ;
    for  (int i=2;i<=n;i++) {
        inv[i]=(p-p/i)*inv[p%i]%p;
    }
}
```



## 3.逆前缀积

这种数据不连续，法2会爆

[P5431 【模板】模意义下的乘法逆元 2 - 洛谷](https://www.luogu.com.cn/problem/P5431)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251207084702172.png" alt="image-20251207084702172" style="zoom:33%;" align="left"/>



```c++
void solve() {
    i64 n,p,k;
    n=read(),p=read(),k=read();
    vector<i64> a(n+1),pre(n+1,1),ipre(n+1,1);
    for (int i=1;i<=n;i++) {
        a[i]=read();
        pre[i]=pre[i-1]*a[i]%p;
    }

    ipre[n]=qpow(pre[n],p-2,p);
    for (int i=n;i>=1;i--) {
        ipre[i-1]=ipre[i]*a[i]%p;//逆前缀积
    }

    i64 ans=0,cur=k%p;
    for (int i=1;i<=n;i++) {
        ans=(ans+cur*(ipre[i]*pre[i-1]%p))%p;//这个取余的位置很重要
        cur=cur*k%p;
    }
    cout<<ans<<'\n';
}
```





# 组合数，全排列预处理模板

## 函数公式版

```c++
constexpr int P=1e9+7;
i64 jc[mxn+1];
i64 invjc[mxn+1];

i64 qpow(i64 x,i64 y) {
    i64 ans=1;
    while (y) {
        if (y&1) {
            ans=(ans*x)%P;
        }
        x=(x*x)%P;
        y>>=1;
    }
    return ans;
}

//逆元
i64 inv(i64 x) {
    return qpow(x,P-2)%P;
}

//阶乘，逆元的预处理
void init() {
    jc[0]=1;
    invjc[0]=inv(jc[0]);
    for (i64 i=1;i<=mxn;i++) {
        jc[i]=jc[i-1]*i%P;
    }

    invjc[mxn]=inv(jc[mxn]);
    for (i64 i=mxn-1;i>=0;i--) {
        invjc[i]=invjc[i+1]*(i+1)%P;
    }

}

//组合数预处理
i64 binom(i64 n,i64 k) {
    if (k>n||k<0) return 0;
    return jc[n]*invjc[k]%P*invjc[n-k]%P;
}

//全排列
i64 perm(i64 n,i64 k) {
    if (k>n||k<0) return 0;
    return jc[n]*invjc[n-k]%P;
}

void add(i64 &x, i64 y) {
    x = ((x + y) % P + P) % P;
}
 
void mul(i64 &x, i64 y) {
    x = (x * y % P + P) % P;
}
```



## 杨辉三角版

* 因为当不取模，且数字比较大的时候，用jc之类的组合数公式就有溢出的风险（得用__int128)，这时推荐数位DP

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





# 组合数学

## 卡特兰数



```c++
constexpr i64 P=1e9+7;

i64 n,p,q;
i64 jc[mxn+1];
i64 invjc[mxn+1];

i64 qpow(i64 x,i64 y) {
    i64 ans=1;
    while (y) {
        if (y&1) {
            ans=(ans*x)%P;
        }
        x=(x*x)%P;
        y>>=1;
    }
    return ans;
}

i64 inv(i64 x) {//逆元
    return qpow(x,P-2)%P;
}

void init() {//阶乘，逆元的预处理
    jc[0]=1;
    invjc[0]=inv(jc[0]);
    for (i64 i=1;i<=mxn;i++) {
        jc[i]=jc[i-1]*i%P;
    }

    invjc[mxn]=inv(jc[mxn]);
    for (i64 i=mxn-1;i>=0;i--) {
        invjc[i]=invjc[i+1]*(i+1)%P;
    }

}

i64 binom(i64 n,i64 k) {//组合数预处理
    return jc[n]*invjc[k]%P*invjc[n-k]%P;
}

i64 catalan(i64 n) {
    return (binom(2*n,n)-binom(2*n,n-1)+P)%P;//通用公式
}
```



如果题目数据非常小(n<=35)，用递推公式

1 , 1 , 2 , 5 , 14 , 42, 132 , 429 ,1430

```c++
catalan[0]=1;
catalan[i] = catalan[i-1] * (4*i-2) / (i+1)   
```



```c++
1.catalan[n] = (binom(2*n,n)-binom(2*n,n-1)+P)%P
2.catalan[n] = catalan[n-1] * (4*n-2) / (n+1)
3.catalan[n] = ∑ catalan[i]*catalan[n-1-i] //(i从0到n-1) ，这一条公式往往是在我们做题时发现答案可以这么表示然后使用卡特兰数
```





### 模型

**1.括号序列计数**

由n堆左右括号构成的合法的括号序列数

[C-打牌的贝贝_牛客练习赛105](https://ac.nowcoder.com/acm/contest/44749/C)



**2.出栈序列计数**

一个栈（无穷大）的进栈顺序1，2，......n有多少个不同的出栈顺序

[P1044 [NOIP 2003 普及组\] 栈 - 洛谷](https://www.luogu.com.cn/problem/P1044)



**3.二叉树计数**

n个节点可以构造出多少个不同的二叉树



**4.三角剖分计数**

对角线不相交的情况下，将一个凸多边形区域分成三角形区域的方法数



**5.数列计数**

n个+1和n个-1构成2n项a1+a2+......,ak>=0 (k=1,2,......,2n)的序列数量个数



**6.圆内不相交弦计数**

在圆上选择2n个点，将这些点承兑连接起来是的所得到的n条线段不相交的方法数



**7.路径计数**

笛卡尔坐标系中，从(0,0)出发，每次只能向上或向右走，且不能越过 y=x这条直线，求走到(n,n)的不同路径的数量











## 数学期望

期望具有线性



* 把期望理解成均值，多个均值相乘， 总和/方案数

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251207090413771.png" alt="image-20251207090413771" style="zoom:33%;" align="left"/>

[G-永远亭的小游戏_Cloudflare纪念赛](https://ac.nowcoder.com/acm/contest/123509/G)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251207090659877.png" alt="image-20251207090659877" style="zoom:33%;" align="left"/>

```c++
void solve() {
    i64 n,m,k;
    cin>>n>>m>>k;
    i64 x,ans=1,sa=0,sb=0,sc=0;
    for (int i=1;i<=n;i++) {
        cin>>x;
        sa=(sa+x)%P;
    }
    for (int i=1;i<=m;i++) {
        cin>>x;
        sb=(sb+x)%P;
    }
    for (int i=1;i<=k;i++) {
        cin>>x;
        sc=(sc+x)%P;
    }
 
    ans=sa*sb%P*sc%P;
    ans=(ans*qpow(n,P-2))%P;
    ans=(ans*qpow(m,P-2))%P;
    ans=(ans*qpow(k,P-2))%P;
 
 
    cout<<ans<<'\n';
}
```



[F-小苯的数字分块_牛客周赛 Round 125](https://ac.nowcoder.com/acm/contest/126319/F)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20260105165322607.png" alt="image-20260105165322607" style="zoom:45%;" align="left"/>

O(n)

* 所谓期望，这里可以理解成能弄成多少个块（均值），把每个块出现的概率相加即可

* 能否弄出块，那就是看相邻二者选的是否相同，我们可以直接考虑1-相同，而相同的概率即为 

   交集/（二者区间长度之积），记得ans初始=1(因为必能出1个)，

* 处处取模！！！







## 排列组合

### 排序

#### 错排

> 这是一道板子题

[P4071 [SDOI2016\] 排列计数 - 洛谷](https://www.luogu.com.cn/problem/P4071)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251207092203136.png" alt="image-20251207092203136" style="zoom:33%;" align="left"/>

```c++
i64 jc[mxn+1],inv[mxn+1],d[mxn+1];//错排种数

i64 qpow(i64 a,i64 b) {
    i64 res=1;
    while(b) {
        if(b&1) res=res*a%P;
        a=a*a%P;
        b>>=1;
    }
    return res;
}

void init() {
    jc[0]=1;
    for (int i=1;i<=mxn;i++) {
        jc[i]=jc[i-1]*i%P;
        inv[i]=qpow(jc[i],P-2);
    }

    d[1]=0,d[2]=1,d[3]=2;
    for (int i=4;i<=mxn;i++) {
        d[i]=(i-1)*(d[i-1]+d[i-2])%P;
    }
}

void solve() {
    i64 n,m;
    cin>>n>>m;

    if (n-m==1) cout<<0<<'\n';
    else if (n==m) cout<<1<<'\n';
    else if (m==0) cout<<d[n]<<'\n';
    else cout<<jc[n]*inv[n-m]%P*inv[m]%P*d[n-m]%P<<'\n';
}
```



#### 归并排序

[D-配对_牛客2025秋季算法编程训练联赛6-基础组](https://ac.nowcoder.com/acm/contest/120455/D)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251207092824460.png" alt="image-20251207092824460" style="zoom:33%;" align="left"/>

对于前k个数，我们并不想把a,b中的大数浪费在他们身上，k及其后，我们力求平均分配

```c++
vector<int> a(n+1),b(n+1);
    for (int i=1;i<=n;i++) {
        cin>>a[i];
    }
    for (int i=1;i<=n;i++) {
        cin>>b[i];
    }

    sort(a.begin()+1,a.end());
    sort(b.begin()+1,b.end());
    reverse(b.begin()+n-k+1,b.end());

    int ans=inf;
    for (int i=n-k+1;i<=n;i++) {
        ans=min(ans,a[i]+b[i]);
    }
    cout<<ans<<'\n';
```



#### 例题1

> 给你两个长度均为n的整数数组a和b。
> 您可以选择任意一个索引子集，并交换这些位置上的元素(即对子集中的每个i进行交换(a,b)。如果交换后，两个数组都按非降序排序，则该索引子集被视为好。
> 你的任务是计算好子集的数量。由于答案可能很大，请打印出998244353的模数。

考虑每个位置能否调换
要同时满足2种情况才能有选择，只满足1种的要么不可换要么必换，不会影响ans的取值

```c++
i64 ans=1;
    for (int i=1;i<=n;i++) {
        int cur=0;
        cur+=a[i]>=a[i-1]&&b[i]>=b[i-1];
        cur+=a[i]>=b[i-1]&&b[i]>=a[i-1];
        ans=ans*cur%P;
    }
```



## 隔板法

* 将x个元素分为y组，  ans= binom(x-1,y-1);



https://ac.nowcoder.com/acm/contest/120566/B

* 首先得对题目进行转换，转成字符串：x个0，n-x个1，t个01/10，问方案数。
* 我们还能进一步转换：t+1= 连续0，连续1段之和
* 这得交替的，因此0和1连续段之差至多为1，也就是我们要把x分为 (t+1)/2个，y分为(t+1-(t+1)/2)个，相乘，然后再搞一遍:  把y分为 (t+1)/2个，y分为(t+1-(t+1)/2)个,相乘，加到上面那个里面
* 对了，需要对 t=0进行特判





## 斐波那契数列

1,2项之后，fa%fb==0等价于a%b==0



## 高中数学

### 对勾函数

[Problem - C - Codeforces](https://codeforces.com/contest/2137/problem/C)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251209133125457.png" alt="image-20251209133125457" style="zoom:33%;" align="left"/>

> 积一定，对勾，奇偶分析即可





# 中位数



[问题 - D - 代码力 --- Problem - D - Codeforces](https://codeforces.com/contest/2149/problem/D)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251207091737885.png" alt="image-20251207091737885" style="zoom:33%;" align="left"/>

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251207091819097.png" alt="image-20251207091819097" style="zoom:33%;" align="left"/>

```c++
#include <bits/stdc++.h>
using namespace std;
using i64=long long;

int n;
string s;
/*向中间靠拢为最优
 两个数组：始 a[0],a[1],a[2],...a[m]
         末 end[0],end[1],end[2],...end[m]
         end[i+1]-end[i]=1
    ans1=abs(a[i]-end[i])=abs(a[i]-i-end[0])求和
    先将a[i]-=i;
    令end[0]=a[中位数]
 */

i64 solve(char ch) {
    vector <int> pos;
    for (int i=0;i<=n;i++) {
        if (s[i]==ch) pos.push_back(i);//存位置
    }

    int len=pos.size();
    for (int i=0;i<len;i++) {
        pos[i]-=i;
    }

    i64 ans=0;
    for (int i=0;i<len;i++) {
        ans+=abs(pos[i]-pos[len/2]);
    }
    return ans;
}

int main() {
    int t;
    cin >> t;
    while (t--) {
        cin>>n>>s;
        cout<<min(solve('a'),solve('b'))<<'\n';
    }
    return 0;
}
```





# 计算几何

## 基本数据

```c++
double pi=acos(-1.0);//精确的圆周率
f80 phi= (sqrt(5.0)+1.0)/2.0 =1.618, 黄金分割数

int x=log10(n);//目前只知道10


```



## 函数

```c++
hypot(x,y);//求以x,y为直角边的斜边
```



```c++
constexpr f80 eps = 1e-8; // 根据题目精度要求进行修改
const f80 pi = acos(-1.0L); // 3.1415926....(到时候用弧度制)

// 取符号函数
int sgn(auto x) {
    // 精度范围内的近似相等
    if (abs(x) < eps) return 0;
    return x > 0 ? 1 : -1;
}

template<typename T>
struct pos {
    T x, y;

    template<typename U>
    operator pos<U>() const {
        static_assert(is_convertible_v<T, U>, "T must be convertible to U");
        return {static_cast<U>(x), static_cast<U>(y)};
    }

    pos operator+(const pos &b) const { return {x + b.x, y + b.y}; }

    pos operator-(const pos &b) const { return {x - b.x, y - b.y}; }

    T operator^(const pos &b) const { return x * b.y - y * b.x; }

    T operator*(const pos &b) const { return x * b.x + y * b.y; }

    pos operator*(const T &b) const { return {x * b, y * b}; }

    pos operator/(const T &b) const { return {x / b, y / b}; }

    bool operator==(const pos &b) const { return !sgn(x - b.x) && !sgn(y - b.y); }

    [[nodiscard]] T abs2() const { return x * x + y * y; }
};

using Pi = pos<i64>;
using Pf = pos<f80>;

// 获得点 a 到点 b 的距离
f80 dist(auto a, auto b) {
    return sqrt((a - b).abs2());
}

// 获得点 a 的单位化向量
auto norm(auto a) {
    return a / hypot(a.x, a.y);
}

// 判断点 p 在向量 ab 的哪一侧
//左侧(逆时针(o,pi))：正数,右侧：负数，共线:0
int side(auto p, auto a, auto b) {
    return sgn((a - p) ^ (b - p));
}

// 判断点 p 是否在线段 ab 上
bool ons(auto p, auto a, auto b) {
    return side(p, a, b) == 0 && sgn((a - p) * (b - p)) <= 0;
}

// 判断线段 ab 与线段 cd 是否存在交点
bool iss(auto a, auto b, auto c, auto d) {
    if (ons(a, c, d) || ons(b, c, d) || ons(c, a, b) || ons(d, a, b)) return true;
    if (side(a, b, c) * side(a, b, d) >= 0) return false;
    if (side(c, d, a) * side(c, d, b) >= 0) return false;
    return true;
}

// 判断直线 ab 与线段 cd 是否存在交点
bool ils(auto a, auto b, auto c, auto d) {
    return side(a, b, c) * side(a, b, d) <= 0;
}

// 判断直线 ab 与直线 cd 是否平行
bool para(auto a, auto b, auto c, auto d) {
    return sgn(a - b ^ c - d) == 0;
}

// 获得直线 ab 与直线 cd 的交点
Pf ill(Pf a, Pf b, Pf c, Pf d) {
    auto u = b - a, v = d - c;
    auto t = (a - c ^ v) / (v ^ u);
    return a + u * t;
}

// 获取点 p 在直线 uv 上的垂足
Pf foot(Pf p, Pf u, Pf v) {
    auto dir = norm(u - v);
    return u + dir * (dir * (p - u));
}

// 获取向量 a 逆时针旋转角度 r 后的向量， r ∈ [0, PI]
Pf rot(Pf a, f80 r) {//a就是两点相减
    Pf b = {sin(r), cos(r)};
    return {a ^ b, a * b};
}

// 获取三角形 ABC 的面积
f80 tria(auto a, auto b, auto c) {
    return abs(b - a ^ c - a) / 2;
}

// 获取三角形 ABC 的面积
i64 tria2(Pi a, Pi b, Pi c) {
    return abs(b - a ^ c - a);
}

// 获取闭合多边形 p 的面积
f80 polya(auto &p) {
    f80 res = 0;
    for (int i = 0; i < p.size(); i++) res += p[i] ^ p[(i + 1) % p.size()];
    return abs(res) / 2;
}
```



https://ac.nowcoder.com/acm/contest/120563/H

```c++
void solve() {
    Pi A, B;
    cin >> A.x >> A.y >> B.x >> B.y;

    if (A == B) {
        cout << "no answer" << '\n';
        return;
    }

    Pi O(0, 0), X(1, 0);
    if (A.y == B.y) {
        if (tria2(A, B, O) == 4) {
            cout << 0.0 << '\n';
        } else {
            cout << "no answer" << '\n';
        }
        return;
    }

    f80 len = dist(A, B);
    Pf d = norm(rot(B - A, pi / 2));//法向量
    Pf AA = Pf(A) + d / len * 4;//将直线AB平移h个单位
    Pf BB = Pf(B) + d / len * 4;
    Pf C = ill(AA, BB, O, X);
    cout << C.x << '\n';
}
```









































