# STL

[TOC]

# set

## 用法

* set 里的元素自动升序  
* 寻找：`auto it=s.find(3) ;`  找到值为3的迭代器， 记得检查it!=s.end();找不到的话会指向第n+1个元素，vector也可以find
  * 找到迭代器后，求值  `int x=*s.begin(), int y=*it;`

* 删除： s.erase(it) ;  s.erase(3); 都可以
  * 但推荐 it=s.erase(it); 不然删一次迭代器就失效了，但还是要判断it!=s.end();
* s.insert(1);





[Problem - 1515C - Codeforces](https://codeforces.com/problemset/problem/1515/C)

* set<pair<int,int>>

```c++
    set<pair<int,int>> s;
    for (int i=1;i<=m;i++) {
        s.emplace(0,i);
    }

    cout<<"YES\n";
    for (int i=1;i<=n;i++) {
        auto tp=s.begin();
        int id=tp->second;
        int w=tp->first+h[i];
        cout<<tp->second<<" ";
        s.erase(tp);
        s.insert({w,id});
    }
```





## 区间覆盖



[E - Cover query](https://atcoder.jp/contests/abc435/tasks/abc435_e)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251211154154752.png" alt="image-20251211154154752" style="zoom:33%;" align="left"/>



> 已亲测，用l<=sr找有重叠的区间才是对的

```c++
void solve() {
    int n,q;
    cin>>n>>q;

    set<pair<int,int>> st;
    set<pair<int,int>> ::iterator itr;//强烈建议写成auto,迭代器
    st.insert({n,1});
    int ans=n;

    while (q--) {
        int l,r;
        cin>>l>>r;

        vector<pair<int,int>> res;
        itr=st.lower_bound({l,-1});
        while (itr!=st.end()) {
            int sl=(*itr).second;
            int sr=(*itr).first;

            if (r<sl) break;
            if (sl<l&&r<sr) {//要不要取等，需要关注res那里会不会出错
                res.push_back({l-1,sl});
                res.push_back({sr,r+1});
            }else if (sl<l&&l<=sr) {
                res.push_back({l-1,sl});
            }else if (sl<=r&&r<sr) {
                res.push_back({sr,r+1});
            }

            ans-=min(r,sr)-max(l,sl)+1;//删掉重叠部分
            itr=st.erase(itr);
        }

        int sz=res.size();
        for (int i=0;i<sz;i++) {
            st.insert(res[i]);
        }
        cout<<ans<<'\n';
    }
    
}

```







# multiset

* 不会去重，自动升序
* 时间复杂度： O(log n)



```c++
multiset <int> s;
multiset s(b.begin(),b.end());//copy

//O(log n)
s.insert(x);//插入  
s.extract(x)//删除1个值为x的元素
s.erase(x);//删除所有值为x的元素

auto it = s.find(x); //切记没有的话会返回 s.end();
if (it != s.end()) s.erase(it);//删除指向x的迭代器，删一个

s.empty();//判断是否为空
swap(s1,s2);//交换两个集合

s.size();
auto it=s.find(x); //找迭代器，找不到会返回s.bend();
s.contains(x);//和find()一样，但返回bool值，找不到会返回0，更好用
s.count(x);//元素出现次数

s.resize();
auto it = s.lower_bound();  
auto it = s.upper_bound();

//O(1)
*s.begin();//查询

int x=*(--it);//下一个
cout<<*it;
```





# tuple

```c++
(1) vector<tuple<int,int,int>> all(n+1);  //多元组，不一定要3个

(2)tuple<i64,i64,i64> ans{-inf,-1,-1};//初始化

(3) sort(all.begin(),all.end());  //以第一个升序

(4) int x=get<0> (all[i]); //提取元素
```



## 矩阵重排

[Problem - 1517B - Codeforces](https://codeforces.com/problemset/problem/1517/B)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251223195325415.png" alt="image-20251223195325415" style="zoom:33%;" align="left"/>

* 会tuple后，直接填入即可

```c++
void solve() {
    int n,m;
    cin>>n>>m;
    vector<vector<int>> a(n,vector<int> (m));
    vector<tuple<int,int,int>> all;
    for (int i=0;i<n;i++) {
        for (int j=0;j<m;j++) {
            cin>>a[i][j];
            all.emplace_back(a[i][j],i,j);
        }
    }

    sort(all.begin(),all.end());
    vector<vector<int>> ans(n,vector<int>(m));
    for (int i=0;i<m;i++) {
        int ha=get<1> (all[i]);
        int tp=get<0> (all[i]);
        ans[ha][i]=tp;
    }

    for (int i=m;i<n*m;i++) {
        int ha=get<1> (all[i]);
        int tp=get<0> (all[i]);
        for (int j=0;j<m;j++) {
            if (ans[ha][j]) continue;
            ans[ha][j]=tp;
            break;
        }
    }

    for (int i=0;i<n;i++) {
        for (int j=0;j<m;j++) {
            cout<<ans[i][j]<<" \n"[j==m-1];
        }
    }
}
```



# vector

## 基本用法

```c++
vector<int> a(n+1);
a.insert(a.end(),a.begin()+1,a.end());//插入位置，从...到...
a.insert(a.end(),a.rbegin(),a.rend()-1);//倒序插入

a.back();  
a.empty();

int cnt = accumulate(a.begin(), a.end(), 0);//累加，0是cnt的初始值
int tp = accumulate(a.begin(), a.end(), 1, multiplies<int>());//累乘，1是tp的初始值

sort(a.begin,a.end());
sort(a.rbegin(),a.rend());//降序
//O(nlog(n))

find(a.begin(),a.end(),x);
//找不到会返回 a.bend();
//时间复杂度 :O(n),慎用小心O(n*n),这是建议开一个pos[i]记录a[i]的位置以实现O(1)的查找


lower_bound,upper_bound ;
//要在非降序数组中才能使用
//O(log(n))
    

min_element(a.begin(),a.end());//返回第一个最小值的索引
*min_element(a.begin(),a.end());//返回最小值


//删除
auto it=find(a[j].begin(),a[j].end(),x);
if (it!=a[j].end()) {
     a[j].erase(it);
}
```







## array

```c++
vector<array<int,2>> a(n);
//1.在固定列数时首选array ,存点集，坐标对
//2.开销小，内存连续
```



三元组/多元组，调用起来可能比tuple更方便

```
array<i64,3> ans={-infl,-1,-1};
```



# map

```c++
//(1). 统计个数
map<int,int> mp;
int x=mp.count(1);

vector<map<int,int>> mp;
int x=mp[1].count(1);

//(2).添加
map<int,int> mp;
mp.insert({sum,i});

//(3).查询第一个
auto it=mp.begin();
if(it!=mp.bend()) int x=it->first;

```



# unordered_map

```c++
unordered _map //时间复杂度O(1)
mp.count(m-i)// 检查是否存在 m-i 的键，返回0/1    
    
```



