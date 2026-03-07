[TOC]





# 数学

## 欧几里得距离

$$
d((x_1,y_1),(x_2,y_2))=\sqrt{(x_1-x_2)^2 + (y_1-y_2)^2}
$$

## 曼哈顿距离

设两点：

$$
(x_1, y_1), (x_2, y_2)
$$

则有
$$
d((x_1,y_1),(x_2,y_2))=|x_1 - x_2| + |y_1 - y_2|
$$



**对于曼哈顿距离，我们可以将其旋转45°，转化为切比雪夫距离，令u=x+y,v=x-y, 则** 
$$
d((x_1,y_1),(x_2,y_2))=max(|u_1-u_2|,|v_1-v_2|)
$$


https://atcoder.jp/contests/abc178/tasks/abc178_e?utm_source=chatgpt.com

这里，我们只需要维护4个量即可  max_u,min_u,max_v,min_v, 于是，我们即可实现O(n)遍历

```c++
void solve() {
    int n;
    cin>>n;
    vector<pair<i64,i64>> a(n);
    for(int i=0;i<n;i++) {
        i64 x,y;
        cin>>x>>y;
        a[i]={x+y,x-y};
    }

    i64 minu=infl,minv=infl,maxu=-infl,maxv=-infl;
    for (auto [u,v] : a) {
        minu=min(minu,u);
        minv=min(minv,v);
        maxu=max(maxu,u);
        maxv=max(maxv,v);
    }

    i64 ans=max(maxu-minu,maxv-minv);
    cout<<ans<<'\n';
}
```





## 切比雪夫距离

$$
d((x_1,y_1),(x_2,y_2))=\max(|x_1-x_2|, |y_1-y_2|)
$$













