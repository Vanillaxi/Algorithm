# 贪心

[TOC]

# 双端队列型

## 比较对抗型

>  两队比较，比赛得分

### 田忌赛马

[P1650 田忌赛马 - 洛谷](https://www.luogu.com.cn/problem/P1650)

[P2587 [ZJOI2008\] 泡泡堂 - 洛谷](https://www.luogu.com.cn/problem/P2587)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251207163236676.png" alt="image-20251207163236676" style="zoom:33%;" align="left"/>

```c++
tip:
(1)deque
(2)if(a最弱>b最弱) a.pop_front(),b.pop_front();
 else if(a最强>b最强) a.pop_back(),b.pop_back();
 else {
 if(a最弱==b最强) 平//(说明a==b);
 a.pop_front(),b.pop_back();
 }
```



## 合并延迟型

> * 环形结构，相邻操作
> * 避免大值过早参与



[Problem - C - Codeforces](https://codeforces.com/contest/2166/problem/C)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251208135418735.png" alt="image-20251208135418735" style="zoom:33%;" align="left"/>

```c++
    while (dq.size()>1) {
        i64 tp=dq.front();
        dq.pop_front();
        if (tp>dq.front()) dq.push_back(tp);
        else if (tp>dq.back()) {
            dq.push_front(tp);
            dq.push_front(dq.back());
            dq.pop_back();
        }else ans+=min(dq.front(),dq.back());
    }

```







## 滑动窗口最值型

> * 最值维护型
> * 单调队列



```c++
struct node {
    int tp,id;
}p;

void solve() {
    int n,k;
    cin>>n>>k;

    deque<node> mn,mx;
    vector<int> a(n-k+2),b(n-k+2);
    for (int i=1;i<=n;i++) {
        int x;
        cin>>x;
        p.tp=x,p.id=i;

        while (!mn.empty()&&mn.back().tp>=x) mn.pop_back();
        while (!mx.empty()&&mx.back().tp<=x) mx.pop_back();

        mn.push_back(p),mx.push_back(p);

        while (!mn.empty()&&mn.front().id<i-k+1) mn.pop_front();
        while (!mx.empty()&&mx.front().id<i-k+1) mx.pop_front();

        if (i>=k) {
            a[i-k+1]=mn.front().tp;
            b[i-k+1]=mx.front().tp;
        }
    }

    for (int i=1;i<=n-k+1;i++) {
        cout<<a[i]<<" \n"[i==n-k+1];
    }

    for (int i=1;i<=n-k+1;i++) {
        cout<<b[i]<<" \n"[i==n-k+1];
    }

}
```



## 顺序调整型

> * 字典序最小，重排
> * 贪心选择位置

```c++
	deque<char> dq;
    for (char c:s) {
        if (c<=dq.front()) dq.push_front;
        else dq.push_back(c);
    }
```



## 博弈策略型

> * 两端取数，博弈
> * 对称性博弈

```c++
void solve() {
    deque<int> dq;
    int player1=0,player2=0;
    bool turn=true;//true为玩家1

    while (!dq.empty()) {
        if (case1) {
            //取队首
            if (turn) player1+=dq.front();
            else player2+=dq.front();
            dq.pop_front();
        }else {
            //取队尾
            if (turn) player1+=dq.back();
            else player2+=dq.back();
            dq.pop_back();
        }
        turn=!turn;
    }
    
}
```



# 优先队列型



[P1090 [NOIP 2004 提高组\] 合并果子 - 洛谷](https://www.luogu.com.cn/problem/P1090)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251208131733625.png" alt="image-20251208131733625" style="zoom:33%;" align="left"/>

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251208131754629.png" alt="image-20251208131754629" style="zoom:33%;" align="left"/>





```c++
    priority_queue<i64,vector<i64>,greater<i64>> pq;
    for (int i=1;i<=n;i++) {
        i64 x;
        cin>>x;
        pq.push(x);
    }


    i64 ans=0;
    while (pq.size()>1) {
        i64 x,y,z;
        x=pq.top();
        pq.pop();
        y=pq.top();
        pq.pop();
        z=x+y;
        ans+=z;
        pq.push(z);
    }
```



[P1334 瑞瑞的木板 - 洛谷](https://www.luogu.com.cn/problem/P1334)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251208132004381.png" alt="image-20251208132004381" style="zoom:33%;" align="left"/>

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251208132025730.png" alt="image-20251208132025730" style="zoom:33%;" align="left"/>

> 逆向思维，其实跟第一题一样



# 填坑法



[P5019 [NOIP 2018 提高组\] 铺设道路 - 洛谷](https://www.luogu.com.cn/problem/P5019)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251208132337692.png" alt="image-20251208132337692" style="zoom:33%;" align="left"/>

> 先填前面的，如果a[i+1]<=a[i],那就可以顺带免费填a[i+1],否则`ans+=a[i+1]-a[i]`



# 二元

## w1+s1>w2+s2型

[P1842 [USACO05NOV\] 奶牛玩杂技 - 洛谷](https://www.luogu.com.cn/problem/P1842)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251208132754790.png" alt="image-20251208132754790" style="zoom:33%;" align="left"/>

> 从特殊到一般，构造相邻的两头，
> 对于 w1-s2>w2-s1 显然是让奶牛1在下面，—> w1+s1>w2+s2 那么就是w+s大的在下面



# 贪心匹配（待补...



[Problem - C - Codeforces](https://codeforces.com/contest/2170/problem/C)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251208135819355.png" alt="image-20251208135819355" style="zoom:33%;" align="left"/>



[F-小红出牌（hard）_牛客周赛 Round 123](https://ac.nowcoder.com/acm/contest/125954/F)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251222145007777.png" alt="image-20251222145007777" style="zoom: 50%;" align="left"/>

怎样才会再次出现顺子，减少序列？ 

* 考虑全为不同的牌， 当前位的a[i]，如果有a[i]-1或a[i]+1那就可以把a[i]接过去，两个都有ans-1,两个都没ans+1,else 不变
* 考虑存在相同牌，其实思路差不多 就是看看还有没有a[i-1]，a[i+1]可以用，所以我们推广一下，就是比较cnt[a[i]],cnt[a[i]-1],cnt[a[i]+1]





[D-小红打牌_牛客周赛 Round 123](https://ac.nowcoder.com/acm/contest/125954/D)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251222153448879.png" alt="image-20251222153448879" style="zoom:45%;" align="left"/>

* 显然，b[i]>=3&&b[i+1]>=3这个约束更大，首先统计出cnt2,cnt4,于是我们枚举b[i]>=3&&b[i+1]>=3那些,然后cnt2-=2(这里用x,y,因为要复原), 还要看看b[i]>=5,b[i]>=7,及b[i+1]因为他们也能贡献2，更新x,y， 接着调用cnt2,cnt4,给他匹配，(2的话就是一堆里选2个，4直接)









# 贪心选择



[Problem - C - Codeforces](https://codeforces.com/contest/2173/problem/C)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251209194823901.png" alt="image-20251209194823901" style="zoom:33%;" align="left"/>



> 首先，分析第一个t=b[1],这必定是a[i]min,接着我们只需检索a[i]中是否含盖所有小于k的t的倍数
>
> 若无——>-1 ,有就删了它，
>
> 我们用这个策略继续选b2,b3......就是每次选min

> 这里用set好写,记得用map,不然易mle



```c++
    set<int> s;
    map<int,int> vis;
    for (int i=1;i<=n;i++) {
        int x;
        cin>>x;
        s.insert(x);
        vis[x]=1;
    }

    vector<int> ans;
    while (!s.empty()) {
        int t=*s.begin();
        s.erase(s.begin());
        ans.push_back(t);

        for (int i=t;i<=k;i+=t) {
            if (!vis[i]) {
                cout<<-1<<'\n';
                return;
            }
            s.erase(i);
        }
    }
```



[Problem - B - Codeforces](https://codeforces.com/contest/2116/problem/B)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251223103159490.png" alt="image-20251223103159490" style="zoom:40%;" align="left"/>

注意到 , 2^(i+1)=2^i+2^i; 因此首先如果我把选择权放到p，我在p那里取最大的，就不会有比他更大的组合，同理放到q也得分析，因此我们其实只需要两个量p,q分别取最大是的res

* 最大值大于别人的最大值，那必然大于等于
* 若相等，那就比一下min

```c++
    i64 mp=-1,mq=-1,mpp=-1,mqq=-1;//滚动变量更简洁
    for (int i=0;i<n;i++) {
        if (p[i]>mp) {
            mp=p[i];
            mpp=i;
        }
        if (q[i]>mq) {
            mq=q[i];
            mqq=i;
        }

        if (mp>mq||(mp==mq&&q[i-mpp]>=p[i-mqq])) cout<<(res[mp]+res[q[i-mpp]])%mod<<" ";
        else cout<<(res[mq]+res[p[i-mqq]])%mod<<" ";
    }
```

* 泪的教训，这里不能直接用max,因为取模后的数的相对大小可能会变



[Problem - B - Codeforces](https://codeforces.com/contest/2109/problem/B)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251223142313581.png" alt="image-20251223142313581" style="zoom:50%;" />



* 注意到可以分别分析两个维，这并不影响，
* 那么真正需要考虑的是第一刀怎么切，横or竖,哪部分
* 然后打表找规律，注意到/2/2/2.......的规律，考虑二进制，得出结论：一维cnt=bit_width((unsigned) n),n是剩余格子数
* 这个刚好可以证明贪心是对的，我们要选切掉的未必是数量最多的格子，因为5=8，5行9列比8行8列亏
* 每次master都到该维的中心

```c++
void solve() {
    int n,m,a,b;
    cin>>n>>m>>a>>b;

    int x=0,y=0,ans=m+n;
    x=bit_width((unsigned)min((m-b),b-1))+bit_width((unsigned)(n-1));
    y=bit_width((unsigned)min(n-a,a-1))+bit_width((unsigned(m-1)));
    cout<<min(x,y)+1<<'\n';
}
```



[硫酸钡之梦](https://ac.nowcoder.com/acm/problem/270861)

* 先设置vector<i64> a(n+2), 然后就是遍历a, 两个之中选择max的那个即可





[Problem - 1515C - Codeforces](https://codeforces.com/problemset/problem/1515/C)

* 每次都加到高度min的那座塔里面，由于积木的高度不超过x，那么各塔之间我们即使多加了1块上去，也不会超标
* 用set维护

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



## 01串

https://ac.nowcoder.com/acm/contest/120564/F

a个0,b个1, 构造01串,使得各字串mex之和max, 用贡献思想, 0贡献1,1贡献0,  01/10贡献2

* 当a<b 时,我们应该最小化全1串(即将最长的全1串长度min), 

* 当a>=b时,我们应该最小化全0串,

  ```c++
      string s;
      if (a<b) {
          int x=b/(a+1),y=x+1;
          int cy=b%(a+1),cx=a+1-cy;
          s+=string(x,'1');
          cx--;
          while (cx--) s+='0'+string(x,'1');
          while (cy--) s+='0'+string(y,'1');
      }else {
          int x=a/(b+1),y=x+1;
          int cy=a%(b+1),cx=b+1-cy;
          s+=string(x,'0');
          cx--;
          while (cx--) s+='1'+string(x,'0');
          while (cy--) s+='1'+string(y,'0');
      }
  ```

  



# 贪心添加

https://www.luogu.com.cn/problem/P4447

* 首先开几个数组，tot 记录现在有多少组了，need[i]记录各组下一个所需的数，siz[i]记录各组大小，
* 先sort一遍a[i] ，再O(n)遍历a[i], 找到正确的那个need，如果找不到那就得新开一组了，找到的话，就用while找need同的，因为need同，下标越大，siz越小，我们考虑贪心添加



# 区间覆盖

https://www.luogu.com.cn/problem/P1668

* 先按左端点从小到大sort，然后每次都在那一堆候选区间里面选左端点 <=st(我们最左端的还未覆盖的点) ,且右端点max的



# 滑动窗口型

[Problem - C - Codeforces](https://codeforces.com/contest/1982/problem/C)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251216075804447.png" alt="image-20251216075804447" style="zoom:33%;" align="left"/>

这里贪心的时候要注意，res累加时，如果超过r，无需立即清零，而是砍去最前的那个a[i]



[G-小红出千_牛客周赛 Round 123](https://ac.nowcoder.com/acm/contest/125954/G)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251222143243998.png" alt="image-20251222143243998" style="zoom:50%;" align="left"/>

* 先排序去重，再分别以a[i]为滑动窗口的左边界，看窗口内有多少个元素，ans=n-cnt;
* 然后用双指针写



* 对了，注意下unique，sort那些区间左闭右开，`int k=unique(a.begin()+1,a.end())-a.begin()-1;`

-1是因为无论如何他都包括a[0],如果你从a+2开始，那他还包括a[1],a[2]









# 毫无算法可言（数学推理）

[C - Reindeer and Sleigh 2](https://atcoder.jp/contests/abc437/tasks/abc437_c)

<img src="C:\Users\林霖\AppData\Roaming\Typora\typora-user-images\image-20251221104026879.png" alt="image-20251221104026879" style="zoom:50%;" />



主要是列个式子消一下元就好了,可以多头鹿一起拉车......

p拉>=w不拉 ——>转为 p拉>=w-w拉  即p拉+w拉>=w 

或者是p-p不拉>=w不拉 即 p>=p不拉+w不拉

两个都可以



# 括号

[Problem - D1 - Codeforces](https://codeforces.com/contest/2191/problem/D1)

* D1简单型的话，要删除的话，那么我们我们删除的必定是2k个，既然要最长，那么我们只能删除2个了，肯定是在前面删 ")"  ,后面删  "(" 
* 从后遍历，对于 ”（  “ cnt++ ,当遇到 ”  ）“就考虑是否要删除，因为你删除了，对于新形成的b:他前面是=a,后面的话，删除的”）“的下一个就是”（“，就当用”（“替换了”）“，
* 为什么从后遍历： 我们肯定是想在后面开始遍历想办法删除" ( "，因为删后面的 “（ ” 比  前面的优 ，还有我们需要保证我们删的那个 （ ,他后面还有 (, 否则就是无效删除，如果你从前面开始遍历就很麻烦，你一遇到”）“就得开始考虑：
  * 后面有”（“吗，删最近的会简单，删了后，替代的是”（“吗，也就是说得考虑后面情况，因此我们直接从后面开始遍历



# 删数问题

https://www.luogu.com.cn/problem/P1106

考虑还得删m个数，每次都在一个m+1长度的区间里选一个min，



# 均分纸牌

https://www.luogu.com.cn/problem/P1031

* 该贪心策略为O(n)遍历，将余额转移给后者



# 数位

https://ac.nowcoder.com/acm/contest/120561/G

分两种情况讨论：

* l=r,记得处理好前导0
* 然后看看l,r的位数
  * 对于r=1000,我们ans只能为3位数，ans=999
  * 其他 
    * 如果 l 的位数 < r 的位数，先把l变成与r同位的最小数100，1000
    * 同位后，O(log(r)) 从高位开始遍历，l,r 相同ans+=l[i],否则break; 找到第一个不同的位pos  ,  ans[pos] =l[i]-1, 后面的全为9，若pos=l.size(), 那ans=r, 最后一步： ans与r 的反转取max



# 减少量贪心

https://ac.nowcoder.com/acm/contest/120566/A

* 用优先队列维护 `pq.emplace(hypot(x[i],y[i])-hypot(x[i],y[i]-1),i);`   每次都选影响最大的
