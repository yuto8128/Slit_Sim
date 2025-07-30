# 二重スリット実験の数値シミュレーション

<div id="top"></div>

## 使用技術一覧

<!-- シールド一覧 -->
<!-- 該当するプロジェクトの中から任意のものを選ぶ-->
<p style="display: inline">
  <!-- バックエンドの言語一覧 -->
  <a href="https://julialang.org/">
    <img src="https://img.shields.io/badge/-Julia-blue?logo=julia&style=for-the-badge">
  </a>
</p>

## 目次

1. [プロジェクトについて](#プロジェクトについて)
2. [問題設定](#問題設定)
3. [計算結果](#計算結果)


<!-- プロジェクト名を記載 -->

## 2重スリット実験の数値シミュレーション

React、DRF、Terraform のテンプレートリポジトリ

<!-- プロジェクトについて -->

## プロジェクトについて
二重スリット実験の数値シミュレーションし，gif動画として出力させるコードの開発


<!-- プロジェクトの概要を記載 -->
## 問題設定
シュレディンガー方程式は$` \hbar=1, 1/2m = 1 `$として
```math
\frac{\ \partial \psi\ }{\ \partial t\ } = i\left(\frac{\ \partial^2\psi\ }{\ \partial x^2\ } + \frac{\ \partial^2\psi\ }{\ \partial y^2\ } - V\psi  \right)
```
ポテンシャルは
```math
V(x,y) = \left\lbrace 
\begin{aligned}
  &10^3 && (\text{wall})\\
  &0&& (\text{other})
\end{aligned}
\right.
```

## 数値計算法

空間微分，時間微分ともに差分法を用いる．
```math
\psi(x,y,t) \to \psi_{i,j}(t)
```
と定義し
```math
  \frac{\ \partial\psi\ }{\ \partial t\ } \approx \frac{\ \psi_{i,j}(t+\Delta t) - \psi_{i,j}(t) \ }{\ \Delta t \ }
```
```math
\frac{\ \partial^2\psi\ }{\ \partial x^2\ } +  \frac{\ \partial^2\psi\ }{\ \partial y^2\ } \approx \frac{\ \psi_{i+1,j}(t) + \psi_{i,j+1}(t) + \psi_{i-1,j}(t) + \psi_{i,j-1}(t) - 4\psi_{i,j}(t) \ }{\ \Delta x^2 \ }
```
となり，空間格子点(i,j)の時間発展について
```math
\psi_{i,j}(t+\Delta t) = \psi_{i,j}(t) + i\left(\frac{\ \psi_{i+1,j}(t) + \psi_{i,j+1}(t) + \psi_{i-1,j}(t) + \psi_{i,j-1}(t) - 4\psi_{i,j}(t) \ }{\ \Delta x^2 \ } - V_{i,j}   \right)\Delta t
```
が成り立つ。

## 初期条件
$$
\psi(x,y,t=0) = A e^{-(x^2 + (y+a)^2)}e^{iky}
$$

## 環境

<!-- 言語、フレームワーク、ミドルウェア、インフラの一覧とバージョンを記載 -->

| 言語・ライブラリ         | バージョン |
| --------------------- | ---------- |
| Julia                 | 1.11       |
| Plots                 | 1.40.17      |

<a id="計算結果"></a>
## 計算結果
スリットのパラメータは
- スリット半径：hall_size = 0.2
- スリット間距離：hall_pos = 2.0
- スリット数：hall_number = 2

- ![Image](https://github.com/user-attachments/assets/c113d0ef-25a1-45b7-96cf-902139298da7)




<p align="right">(<a href="#top">トップへ</a>)</p>
