# 字符串

[TOC]



# 注意

## 读题

* 字符串序列不是子串，可以不连续



## 语法

```c++
1.sort(a.begin(),a.end());
2.a.erase(pos,n);         删除从pos位置开始的n个值
3.a.push_back(val);
4.reverse(s.begin(),s.end());//还可反转数组
```



# 拼接与大小比较

```c++
bool cmp(string const& a, string const& b) {
    return a+b<b+a;
}
```



```c++
sort(a.begin(),a.end(),[](const auto& p1,const auto&p2){return p1+p2<p2+p1;});
```



# KMP

> (1).  kmp 数组记录的就是目前为止最大的（真前缀=真后缀）
> (2).  动的是模板串，i对pos+1失配后,模板串跳到pos的最长前缀处，pos为0要跳出循环
> (3).  其实真正移动的是模板串



```c++
void solve() {
    string a,b;
    cin>>a>>b;//文本串，模板串
    a='0'+a,b='0'+b;
    int la=a.size()-1,lb=b.size()-1;

    //kmp的创建，自己串自己
    vector<int> kmp(lb+1);
    int pos=0;//上一个匹配成功的东东在模板串中的位置
    for (int i=2;i<=lb;i++) {
        while (pos&&b[pos+1]!=b[i]) pos=kmp[pos];
        if (b[pos+1]==b[i]) pos++;
        kmp[i]=pos;//i失配后的跳跃
    }

    pos=0;
    for (int i=1;i<=la;i++) {
        while (pos&&b[pos+1]!=a[i]) pos=kmp[pos];
        if (b[pos+1]==a[i]) pos++;

        if (pos==lb) cout<<i-lb+1<<'\n';
    }

    for (int i=1;i<=lb;i++) cout<<kmp[i]<<" ";

}
```



# LCS



```c++
void solve() {
    // LCS板子
    string a,b;
    cin>>a>>b;
    a='0'+a,b='0'+b;
    int len1=a.size()-1,len2=b.size()-1;
    vector<vector<int>> dp(len1+1,vector<int>(len2+1,0));
 
    reverse(ans.begin(),ans.end());
    //双指针，路径追踪
    string ans;
    int i=len1,j=len2;
    while (i&&j) {
        if (a[i]==b[j]) {
            ans+=a[i];
            i--,j--;
        }else {
            if (dp[i][j]==dp[i-1][j]) i--;
            else j--;
        }
        for (int i=1;i<=len1;i++) {
            for (int j=1;j<=len2;j++) {
                dp[i][j]=max(dp[i-1][j],dp[i][j-1]);
                if (a[i]==b[j]) dp[i][j]=max(dp[i][j],dp[i-1][j-1]+1);
            }
        }//dp[len1][len2]即为lcs长度(lcs结束)
    }
    cout<<ans;
}
```



> 例题
>
> www.luogu.com.cn/problem/P1435

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251221144413248.png" alt="image-20251221144413248" style="zoom: 33%;" align="left"/>







# 哈希

> 求n个string 中有多少个不同的



```c++
constexpr i64 M1=1926087;
constexpr i64 M2=233333333;
constexpr int B=256;
u64 get_hash1(string &s) {
    u64 res=0;
    for (auto &c:s) {
        res=(res*B+c)%M1;
    }
    return res;
}
u64 get_hash2(string &s) {
    u64 res=0;
    for (auto &c:s) {
        res=(res*B+c)%M2;
    }
    return res;
}
void solve() {
    vector<int> table1(1e7),table2(1e7);
    i64 n;
    cin>>n;
    i64 cnt=0;
    while (n--) {
        string s;
        cin>>s;
        auto p1=get_hash1(s)%table1.size();
        auto p2=get_hash2(s)%table2.size();
        if (table1[p1]&&table2[p2]) continue;
        table1[p1]=1,table2[p2]=1,cnt++;
    }
    cout<<cnt;
}
```



# MEX

[Problem - 1536B - Codeforces](https://codeforces.com/problemset/problem/1536/B)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251208162419779.png" alt="image-20251208162419779" style="zoom:33%;" align="left"/>

> 根据鸽巢原理，对于s,n+(n-1)+(n-2)=3n-3 <26+26*26+26*26*26; 则必定存在len<=3



```c++
#include <bits/stdc++.h>
using namespace std;

using i64 =long long;

constexpr int inf=1e9;
constexpr i64 inf1=1e18;
constexpr int mxn=5e5;

constexpr int P[]={1,26,26*26,26*26*26};
vector<string> v;

//先枚举
void init() {
    for (int len=1;len<=3;len++) {
        for (int s=0;s<P[len];s++) {
            string t;
            for (int i=0;i<len;i++) {
                t+='a'+s/P[len-i-1]%26;//把s当成26进制运算，从最高位开始
            }
            v.emplace_back(t);
        }
    }
}

void solve() {
    int n;
    cin>>n;
    string s;
    cin>>s;

    vector<pair<int,string>> a;
    for (int i=0;i<n;i++) {
        for (int j=1;j<=3&&i+j<=n;j++) {
            a.emplace_back(j,s.substr(i,j));
        }
    }

    sort(a.begin(),a.end());
    a.erase(unique(a.begin(),a.end()),a.end());//其实unique并没有删除

    int ans=0;
    while (ans<int(a.size())&&v[ans]==a[ans].second) ans++;
    cout<<v[ans]<<'\n';
    
}

int main() {
    ios::sync_with_stdio(false);
    cin.tie(nullptr);

    init();
    int t=1;
    cin >> t;
    while(t--) {
        solve();
    }
    return 0;
}
```















