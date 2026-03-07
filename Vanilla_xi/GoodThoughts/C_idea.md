

对于区间问题，一般有两种思路：

1.枚举左端点，用O(1)或者O(log n) 的复杂度算出右端点

2.对于区间，设状态 f(i) 或者 f(i,j) ,考虑转移



# 倍增思想

分治+ 记忆化

二进制



* 静态查询
  * st表（RMQ)
  * 倍增(LCA)



* 动态查询

  * 树状数组
  * 线段树

  

* 动态模拟

  * 水桶传递 [E - Heavy Buckets](https://atcoder.jp/contests/abc438/tasks/abc438_e)
  * 快速幂





## 二进制枚举

水桶传递： [E - Heavy Buckets](https://atcoder.jp/contests/abc438/tasks/abc438_e)

两个倍增表

res这种就是中间状态，只有设计成这样才能在查询时进行综合计算

```c++
    for (int i=1;i<=n;i++) {
        nx[0][i]=a[i];
        res[0][i]=i;
    }

    for (int i=1;i<=30;i++) {
        for (int j=1;j<=n;j++) {
            int k=nx[i-1][j];
            nx[i][j]=nx[i-1][k];
            res[i][j]=res[i-1][j]+res[i-1][k];//i-1利用的是2的幂的加法性质
        }
    }

    while (q--) {
        i64 t,b;
        cin>>t>>b;
        i64 ans=0,pos=b;
        for (int i=0;i<=30;i++) {//按位查询加
            if ((t>>i)&1) {
                ans+=res[i][pos];
                pos=nx[i][pos];
            }
        }
```





# 贡献法



[Problem - G - Codeforces](https://codeforces.com/contest/2185/problem/G)

* 数目太多，组合来组合去，难以组合数，考虑贡献法
* 先算出不动时的所有数组的mex,    ans=t *sum *(n-1), 不动时的所有操作，
* 然后减去变小的mex，加上变大的mex ，得注意一下贡献次数哦

```c++
    i64 t=0;
    vector<vector<int>> a(n);
    map<int,int> cnt;
    for (int i=0; i<n; i++) {
        int l1;
        cin>>l1;
        t+=l1;
        a[i].resize(l1);
        for (int j=0;j<l1;j++) {
            cin>>a[i][j];
            cnt[a[i][j]]++;
        }
    }

    vector<int> m1(n),m2(n);//找第1，2个mex
    i64 sum=0;
    for (int i=0;i<n;i++) {
        sort(a[i].begin(),a[i].end());
        int cur=0;
        for (int j=0;j<a[i].size();j++) {
            if (a[i][j]==cur) cur++;
        }
        m1[i]=cur;
        sum+=cur;

        cur++;
        for (int j=0;j<a[i].size();j++) {
            if (a[i][j]==cur) cur++;
        }
        m2[i]=cur;

    }

    i64 ans=t*(n-1)*sum;
    for (int i=0;i<n;i++) {
        for (int j=0;j<a[i].size();j++) {
            if (a[i][j]<m1[i]) {
                if ((j>0&&a[i][j]==a[i][j-1])||(j+1<a[i].size()&&a[i][j]==a[i][j+1])) continue;
                ans-=(m1[i]-a[i][j])*(n-1);//有n-1次
            }
        }
    }

    for (int i=0;i<n;i++) {
        if (cnt[m1[i]]) ans+=(m2[i]-m1[i])*cnt[m1[i]];//只有cnt[m1[i]]次
    }
```



https://ac.nowcoder.com/acm/contest/120562/H

* 对于a[i] ，如果是第一次出现，那么对于包含a[i] 的区间 i * (n-i+1), 都有贡献，左端点不影响其贡献，（因为a[i]只会对从i到右端点的数产生贡献）， 于是我们把左端点固定，右端点从 i 到 n ，a[i] 对各个数的权值都贡献了1，统计，那么他对每一个子数组的贡献为 1,2,3,....,n-1 ,等差数列求和 ans+= l * r * (r+1)/2;
* 接下来我们考虑a[i] 出现不止一次，对于不是第一次出现的a[i], 显然他的权值 = 他上一个数a[i-1] 的权值，也就是说他对 那些同时包含两个以上的a[i] 的子数组无法产生贡献，于是我们需要来一个pos记录上一个a[i]出现的位置，则 ans +=  (i-poos) *r * (r+1)/2; 



# 二进制（状压）

用二进制（集合）标记状态，数位DP，状压DP常见

https://codeforces.com/contest/2194/problem/C

* 本题将26个字母压成二进制

```c++
    for (int d=1;d<=n;d++) {//枚举周期
        if (n%d) continue;

        string ans;
        for (int i=0;i<d;i++) {//确定每个位置
            int x=(1<<26)-1;
            for (int j=i;j<n;j+=d) {
                int y=0;//该位置的字母并集
                for (int l=0;l<k;l++) y|=1<<(s[l][j]-'a');
                x&=y;//多周期的交集
            }

            if (!x) break;
            ans+='a'+__builtin_ctz(x);//末尾0的个数
        }
        if (ans.size()<d) continue;
        while (ans.size()<n) ans+=ans.substr(0,d);
        cout<<ans<<'\n';
        return;
    }
```



# 分治

## 根号分治

[https:gen//codeforces.com/contest/2197/problem/D](https://codeforces.com/contest/2197/problem/D)

a[i]*a[j]=j-i ;  n^2 肯定爆炸，根号分治（O(n log n) ) 

* sqn= sqrt(n)(向下取整，n为数组长度) ,对于n=2e5, sqn=450，可以直接用
  * a[i]<= sqn：一个一个来
  * a[i]>sqn:  j+=a[i];

* 注意了：我们这里是在算贡献，所以统一一个方向，（而不是想什么i,j)

```c++
    i64 ans=0;
    for (int i=1;i<=sqn;i++) {//左端点的值
        for (int j=1;j<=n;j++) {//看看有没有匹配的右端点
            if (j-1ll*a[j]*i>0&&a[j-1ll*a[j]*i]==i) ans++;//1ll，自己推公式
        }
    }

    for (int i=1;i<=n;i++) {//仍然是左端点
        if (a[i]>sqn) {
            for (int j=i+a[i];j<=n;j+=a[i]) {
                if (a[i]*a[j]==j-i) ans++;
            }
        }
    }
```





