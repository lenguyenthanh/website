---
title: "FLP Impossibility"
date: 2022-01-19T11:35:12Z
math: true
---

## Giới thiệu

[FLP Impossibillity](https://groups.csail.mit.edu/tds/papers/Lynch/jacm85.pdf) là một trong những paper quan trọng nhất về hệ thống phân tán, trong đó nó chỉ ra một số giới hạn mà chúng ta không thể vượt qua được. Ở đây, ba tác giả (Fischer, Lynch, Paterson) đã chỉ ra rằng trong những hệ thống phân tán không đồng bộ mà nó có thể chứa các process lỗi thì không tồn tại một thuật toán đồng thuận nào mà nó có thể đảm bảo sự kết thúc của việc thực thi.


Bài viết này sẽ trình bày lại chứng minh được đưa ra trong paper trên. Bài viết này sẽ được chia thành năm phần:

- Định nghĩa về Consensus, Asynchronous Model
- Phát biểu bài toán (System Model)
- Biểu diễn bài toán bằng toán học (Formal Model)
- Nêu lên mệnh đề được đưa ra trong paper
- Trình bày chứng minh

## Định nghĩa

Chúng ta sẽ bắt đầu bằng một số định nghĩa cần biết về Consensus cũng như Asynchronous Model.

### Consensus

Các thuật toán Consensus được dùng để giải quyết bài toán đồng thuận trên hệ thống phân tán. Bài toán đồng thuận thường được mô tả như sau: Các *process* trong hệ thống muốn thống nhất một giá trị chung. Một hoặc nhiều *process* có thể đề xuất các giá trị ban đầu.

Một thuật toán Consensus được coi là hợp lệ nếu thoả mãn ba điều kiện sau đây:

- **Termination**: Tất cả các *process* bình thường đều sẽ đưa ra quyết định trên một giá trị.
- **Agreement**: Tất cả những *process* đưa ra quyết định thi đều quyết định trên cùng một giá trị.
- **Validity**: Giá trị được đồng thuận phải được đề xuất từ một trong các *process* ở trong hệ thống.

Chúng ta mặc định rằng: Thuật toán Consensus chỉ chính xác khi số lượng *process* bị lỗi sẽ ít hơn một hằng số được định trước.

### Asynchronous Model

Asynchronous là một trong ba giả định về sự đồng bộ (Synchrony) trong hệ thống phân tán (hai giả định còn lại là Synchronous và Partially Synchronous). Với Asynchronous Model, chúng ta sẽ có những tính chất sau:

- Message có thể bị deliver trễ với thời gian không xác định
- Không xác định được tốc độ xử lý của các *process*
- Không có sử dụng synchronized clocks
- Không thể sử dụng các thuật toán dựa vào time out
- Không thể xác định được một process bị lỗi hay nó đang xử lý rất chậm

Giả định về Asynchronous Model là một giả định quan trọng khi phát biểu về bài toán.

## System Model

Khi thiết kế một thuật toán về Distributed System thì System Model là tập hợp các điều kiện cần để thuật toán đó có thể hoạt động một cách chính xác.

Paper này sẽ chứng minh rằng không tồn tại thuật toán Consensus với những điều kiện sau:

- Asynchronos Model
- Messages System là đáng tin cậy
    - Tất cả các *message* đều được deliver đến các *non-faulty process* một và chỉ một lần (nhưng có thể nhận trễ một cách bất kỳ).
- Chỉ cân nhắc lỗi *crash-stop failure* - bị lỗi và dừng hẳn
    - Ở đây chúng ta chỉ xem xét về lỗi crash-stop failure - trường hợp lỗi đơn giản nhất. Do đó với những mô hình lỗi phức tạp hơn thì chúng ta sẽ có cùng kết quả.
- Tối đa một *process* bị lỗi
- Consensus:
    - Đồng thuận trên tập giá trị 0, 1
    - Chỉ cần một số *non-faulty process* đồng thuận trên cùng 1 giá trị (Partially Correct)

Có thể thấy những điều kiện trên sẽ yếu hơn so với các điều kiện thông thường trên các hệ thống phân tán (trừ Asynchronous Model). Do đó, nếu chúng ta chứng minh được rằng không tồn tại thuật toán Concensus trong trường hợp này thì thuật toán Consensus cũng không thể tồn tại với các trường hợp tổng quát hơn (với Asynchronous Model).

## Formal Model

Trong phần này, chúng ta sẽ biểu diễn hệ thống được định nghĩa ở trên dưới dạng toán học và nêu ra kết luận về tính bất khả của bài toán.

### Consensus Protocol

Gọi Consensus Protocol *P* là một hệ thống phân tán bất đồng bộ (Asynchronous Model) bao gồm N *process* ($N >= 2$). Các process có thể trao đổi thông tin bằng cách gửi *message* cho nhau thông qua một *Message System*. Các thành phần đó sẽ được định nghĩa như bên dưới.

### Process

Mỗi một *process* sẽ có những thành phần như sau:
- Một *Input Register* $x_p$ sẽ có giá trị thuộc tập `{0, 1}`.
- Một *Output Register* $y_p$ sẽ có giá trị thuộc tập `{b, 0, 1}`.
    - Khi $y_p$ có giá trị là b có nghĩa là *process* chưa đưa ra quyết định.
    - Giá trị khởi tạo của $y_p$ luôn là b.
    - Giá trị của $y_p$ chỉ có thể thay đổi một lần  duy nhất, hay mỗi một process chỉ có thể đưa ra quyết định một và chỉ một lần.
- Một bộ nhớ trong vô hạn.
- Một Transistion Function(TF).
    - TF là một deterministic function (cùng input sẽ có cùng output).

Tất cả những thành phần kể trên sẽ được gọi là *Internal State* của một process. Chúng ta sẽ ký hiệu $p_I$ là *Internal State* của một *process p*. *Initial State* là *State* ban đầu của một process với tất cả giá trị của các thành phần kể trên (không tính *Input Register*) đều là các hằng số được cho sẵn. State khi mà giá trị của $y_p$ được gán bằng `0` hoặc `1` sẽ được gọi là *Decision State*.

### Message System

Các *process* có thể trao đổi thông tin qua một *Message System* bao gồm những thành phần sau:

#### Message

Một *message* là một cặp `(p, m)`, trong đó:
- `p` là địa chỉ đến *process* `p`
- `m` là nội dung của *message*

Gọi tập `M` là tập hợp của tất cả các *message*.

#### Message Buffer

Tất cả các *message* (đã gửi nhưng chưa được nhận) sẽ được lưu trữ trong một cơ sở dữ liệu tên là `Multiset` được gọi là `Message Buffer(MB)`.

`Multiset` sẽ khác với `Set` thông thường ở một điểm đó là nó có thể lưu nhiều phần tử có giá trị giống nhau.

Sau đây là Pseudocode ví dụ về cách mà `Multiset` hoạt động:

```
val ms = Multiset<Int>() // {} -- bắt đầu với tập rỗng
ms.add(1) // {(1, 1)} -- phần tử 1 có mặt một lần
ms.add(1) // {(1, 2)} -- phần tử 1 có mặt hai lần
ms.remove(1) // {(1, 1)} -- phần tử 1 có mặt một lần
ms.remove(1) // {} -- trở về với tập rỗng
```

`Message Buffer` có hỗ trợ hai hàm sau:

- `send(p, m)`: thêm `(p, m)` vào `MB` - luôn luôn thành công.
- `receive(p)`: Dùng cho các process nhận message từ `MB`. Có hai trường hợp có thể xảy ra khi một process gọi hàm này:
    - Trong trường hợp tồn tại một cặp `(p, m)` trong `MB` thì hàm này hoặc trả về một cặp `(p, m)` sau đó xoá `(p, m)` khỏi `MB` hoặc trả về $\phi$ - giá trị null - một cách ngẫu nhiên.
    - Nếu p không có message nào trong `MB` thì trả về $\phi$.

Hàm `receive` thoả mãn những điều kiện sau đây:
- Nó có thể trả về $\phi$ không xác định nhưng hữu hạn lần.
- Nếu một *process p* thực hiện `receive(p)` vô hạn lần thì nó sẽ (eventually) nhận được toàn bộ message được gửi cho nó.

Ta có thể thấy `MB` này mô phỏng tính chất của `Asynchronous Model` (tính non-deterministic). Các message có thể bị chậm với một thời gian không xác định trước, nhưng nó sẽ dần dần được deliver chính xác một lần duy nhất (với điều kiện là các process gọi hàm `receive` vô hạn lần).

### Configuration

Một *Configuration (C)* của hệ thống bao gồm:
- *Internal State* của tất cả process
- Toàn bộ *message* trong *Message Buffer*

*Initial Configuration (IC)* bao gồm:
- *Initial State* của tất cả process
- *Message Buffer* là tập rỗng

### Step

`Step` là sự thay đổi của `configuration` trong hệ thống với việc một *process p* thực hiện những bước như sau:

1. *p* thực thi hàm `receive`:
    - $(m, MB') = MB.receive(p)$ Với
    - $m \in M \cup \phi$
    - $MB' = MB \setminus m$
2. Gọi `e = (p, m)` thì e sẽ được gọi là một *Event*
3. Sử dụng *Transistion Function* để apply *event e* vào *p*:
    - $(p_I', MS) = e(p) = TF(e, p_I)$
    - $p_I'$ là state mới của *p* sau khi apply `e(p)`
    - `MS` là một tập *message* mới mà *p* muốn gửi tới `MB` khi apply `e(p)`
4. Gửi *message* đến `Message Buffer`: $MB'' = MB' \cup MS$
5. *configuration* mới: $C' = C(p_I', MB'')$

Vì *TF* là một *deterministic function* nên với mỗi *configuration*, kết quả của mỗi *Step* sẽ phụ thuộc hoàn toàn vào *Event* `e=(p,m)`.

Hay *step* là sự apply một *event e* vào một *configuration C*: `C' = e(C)`

#### Faulty/Non-faulty Process

Một *process p* được coi là hoạt động bình thường (non-faulty) khi nó thực thi *step* vô hạn lần (tương đương với việc gọi `receive(p)` vô hạn lần). Nếu ngược lại thì *process* đó sẽ được coi là lỗi (faulty).

### Schedule

Một *Schedule* $\sigma$ từ $C$ là một chuỗi hữu hạn hoặc vô hạn *event* , mà chúng ta có thể apply lần lượt từng *event* vào $C$. Chuỗi các *event* đó được gọi là Run. Chúng ta có thể biểu diễn chúng như sau:

- $\sigma = {e_1, e_2, \cdots, e_n}$, n $\in$ {$1, \infty$}
- $\sigma(C) = e_n(\cdots, e_2(e_1(C))$ - apply *schedule* $\sigma$ vào *C*.

Một *configuration* $C_1$ được gọi là Reachable từ $C$ nếu tồn tại một chuỗi hữu hạn $\sigma$ thoả mãn: $C_1 = \sigma(C)$.

Một *configuration* có thể *reachable* từ một *Initial Configuration* thì được gọi là Accessible.

Từ nay về sau, các *configuration* được nhắc đến đều được hiểu ngầm là một *accessible configuration*.

#### Một số khái niệm khác

Một *configuration C* có Decision Value khi tồn tại ít nhất một *process p* ở Decision State hay $y_p = v; v \in {0, 1}$.

*Run* được gọi là Admissible (hợp lệ) nếu nó có tối đa một *process* lỗi và toàn bộ *mesage* được gửi tới các *non-faulty process* đều được nhận.

*Run* được gọi là Deciding khi tồn tại ít nhất một *process* đạt Decision State.

### Tính chính xác của Consensus Protocol

Consensus Protocol *P* được coi là *partial correct* - đúng một phần - nếu:
- Không tồn tại *accessible configuration* nào có nhiều hơn một Decision Value (tính Agreement).
- $\forall v \in {0, 1}, \exists$ *accessible configuration* C mà Decision Value của C sẽ bằng *v*.

Consensus Protocol P được coi là đúng - *totally correct* nếu nó *partial correct* và mọi *admissible run* đều là *deciding run*.

## Mệnh đề

**Không tồn tại Consensus Protocol mà *totally correct* trong điều kiện có ít nhất một *faulty process*.**


## Chứng minh

Chúng ta sẽ chứng minh mệnh đề này bằng phương pháp phản chứng. Giả sử tồn tại một Consensus Protocol P thoả mãn đề bài, từ đó chỉ ra tồn tại những hoạt cảnh mà P sẽ không thể đưa ra quyết định cuối cùng do đó dẫn đến sự mâu thuẫn. Chúng ta sẽ thực hiện điều đó qua hai bước:

1. Chứng minh tồn tại những *initial configuration* mà quyết định cuối cùng chưa thể xác định.
2. Xây dựng một *admissible run* mà trong toàn bộ quá trình apply nó, *P* không thể đưa ra quyết đinh.

Nhưng trước khi đi vào chứng minh, chúng ta sẽ nêu lên ba bổ đề mà chúng ta sẽ sử dụng trong chứng minh.

### Bổ đề 1 - Tính giao hoán của Schedule

**Cho một Configuration C, 2 Schedule $\sigma_1, \sigma_2$; gọi $C_1 = \sigma_1(C)$, $C_2 = \sigma_2(C)$. Nếu tập hợp các *process* trong $\sigma_1$ và $\sigma_2$ không giao nhau, thì chúng ta có thể apply $\sigma_1$ cho $C_2$, apply $\sigma_2$ cho $C_1$ và cả 2 đều cho ra cùng một Configuration $C_3$ hay $C_3 = \sigma_2(\sigma_1(C)) = \sigma_1(\sigma_2(C))$**

![p2](https://i.imgur.com/fH7O7ED.png)


#### Chứng minh

Đầu tiên ta thấy nếu một *event* $e \notin \sigma_1$ có thể apply vào C thì nó có thể apply vào $C_1$ (vì mỗi message có thể bị trễ một cách bất kỳ). Do đó, chúng ta có thể apply $\sigma_2$ vào $C_1$. Tương tự cho việc apply $\sigma_1$ vào $C_2$. (1)

Gọi $p(\sigma)$ là tập các process liên quan đến một Schedule $\sigma$. Theo đề bài, ta có $p(\sigma_1) \cup p(\sigma_2) = \emptyset$.

Do $\sigma_1$ và $\sigma_2$ chỉ thay đổi State của 2 tập *process* độc lập với nhau trong C nên việc thay đổi thứ tự apply giữa $\sigma_1$ và $\sigma_2$ sẽ không thay đổi Internal State cuối cùng của toàn bộ process. (2)

Ngoài ra Message Buffer có tính giao hoán (tính chất của Multiset). Nên việc thay đổi thứ tự gửi các *message* (từ việc apply $\sigma_1$ và $\sigma_2$) sẽ không thay đổi kết quả cuối cùng của Message Buffer. (3)


Từ (1), (2), (3) ta có đpcm.

### Bổ đề 2

#### Khái niệm

Cho một Configuration C, gọi $V$ là tập hợp của các Decision Value của tất cả các *reachable Configuraton* từ C. C được gọi là *bivalent* nếu $|V| = 2$. C được gọi là *univalent* nếu $|V| = 1$, hay còn được gọi là *0-valent* hoặc *1-valent* tuỳ thuộc vào giá trị của Decision Value là 0 hay 1.

Hay nói cách khác, C được gọi là *bivalent* khi quyết định cuối cùng của C là chưa xác định. C được gọi là *0-valent* nếu 0 sẽ luôn là giá trị được đồng thuận với mọi *admissible run* từ C. Tương tự cho *1-valent*.

Bởi vì P là *totally correct* nên $|V| != 0$.

#### Nội dung

**P luôn luôn có một Initial Configuration là *bivalent***

#### Chứng minh

Giả sử P không có một Initial Configuration nào là *bivalent*, hay với mọi *initial configuration* của P thì nó sẽ là *0-valent* hoặc *1-valent*.

Ta gọi hai *initial configuration* $C_1$, $C_2$ là *kề nhau(adjcent)* nếu tất cả giá trị $x_p$ của chúng chỉ khác nhau ở một *process p*.


Ta thấy, với mọi $C_0$, $C_n$ bất kỳ, tồn tại chuỗi: $[C_0, C_1, \cdots, C_n]$ thoả mãn: $C_i$ và $C_i+1$ là 2 *process* kề nhau (mỗi $C_i$ đều là *initial configuration*) (*).

Do định nghĩa về *partial correct*, P phải có *0-valent* và *1-valent*. Chọn $C_0$ và $C_n$ sao cho $C_0$ là *0-valent* và $C_n$ là *1-valent*. Từ (*) ta thấy, tồn tại hai process kề nhau $C_i$, $C_i+1$ mà $C_i$ là *0-valent* và $C_i+1$ là *1-valent*. Không mất tính tổng quát, ta giả sử  $C_0$, $C_1$ là hai *configuration* đó.

Giả sử `p` là *process* duy nhất mà $C_0$, $C_1$ khác nhau. Bây giờ chọn một *amissible run* $\sigma$ bất kỳ bắt nguồn từ $C_0$ mà `p` sẽ không tham gia vào. Khi đó, chúng ta cũng có thể apply $\sigma$ cho $C_1$.

Ta thấy, $\sigma(C_0) = \sigma(C_1)$ vì toàn bộ Intial State của $C_0$, $C_1$ là giống nhau (trừ `p`) và `p` sẽ không được sử dụng với $\sigma$.

Chú ý: `P` là *totally correct* nên mọi *admissible run* đều là *deciding run*. Vì vậy, *Decision Value* của $\sigma(C_0)$ và $\sigma(C_1)$ phải giống nhau trái ngược với giả thiết đưa ra là  $C_0$ là *0-valent* và $C_1$ là *1-valent* ta có đpcm.


### Bổ đề 3

**Cho `C` là một *bivalent* Configuration của `P`, `e=(p,m)` là một *event* bất kỳ mà nó có thể apply cho `C`. Gọi `T` là tập hợp các Configuratioin có thể *reachable* từ C mà không apply `e`, và D = e(T) = \{$e(E) | E \in T$ và e có thể apply cho E}. Chứng minh rằng D có chứa một *bivalent* Configuration.**

Hay nói một cách đơn giản hơn tồn tại một *reachable* Configuration `C'` từ `C` thoả mãn 2 điều kiện: `C'` là *bivalent* và `e` là *event* cuối cùng được apply trước khi có `C'`.


#### Chứng minh

Đầu tiên ta thấy *message* có thể bị trễ với thời gian bất định (nhưng hữu hạn) nên nếu `e` có thể apply cho `C`, thì e cũng có thể apply cho `C'` $\forall C' \in T$.

Giả sử D chỉ có *univalent* Configuration.

Ký hiệu $E_i$ là một *i-valent* *reachable* Configuration từ C, $i \in {0,1}$. Do C là *bivalent* nên sẽ tồn tại $E_i$ với $i \in {0,1}$.

Với mỗi $E_i$, có 2 trường hợp có thể xảy ra:
- $E_i \in T$, ta có $F_i = e(E_i) \in D$
- $E_i \notin T$, ta có e đã được apply trước khi đạt được $E_i$. Do đó, $\exists F_i \in D$ mà $E_i$ có thể `reachable` từ $F_i$.

Chính vì vậy, trong bất cứ trường hợp nào ta luôn có một cặp $F_i$ và $E_i$ thoả mãn:
- $F_i$ là không phải là *bivalen* vì $F_i \in D$.
- Một trong $F_i$ và $E_i$ có thể `reachable` từ cái còn lại.

Từ đó, ta thấy D sẽ chứa cả `0-valent` và `1-valent`.

Gọi hai Configuration $C_1$ và $C_2$ là hàng xóm (neighbors) của nhau nếu một trong hai là kết của của cái còn lại bằng một Step duy nhất. Hay $\exists e | e(C_1) = C_2 \lor e(C_2) = C_1$.

Dễ thấy tồn tại hai hàng xóm $C_0$ và $C_1$ thuộc `T` thoả mãn: $D_i=e(C_i)$ là *i-valent*,  $i \in {0,1}$.

Không mất tính tổng quát, có thể giả sử $C_1 = e'(C_0)$ với `e'=(p', m')`.

Ở đây cũng có hai trường hợp có thể xảy ra, `p = p'` và `p != p'`.

**Trường hợp 1**: Nếu `p != p'`

Theo mệnh đề 1 ta có: $D_1 = e(C_1) = e(e'(C_0)) = e'(e(C_0)) = e'(D_0)$

Mà ta cũng có $D_1$ là *1-valent*, $D_0$ là *0-valent* => vô lý

![](https://i.imgur.com/dvbaKip.png)


**Trường hợp 2**: Nếu `p = p'`

Xem xét một Deciding Run bất kỳ từ $C_0$, trong đó `p` không tham gia bất cứ Step nào.

Gọi $\sigma$ là Schedule tương ứng với Deciding Run đó.

Gọi $A = \sigma(C_0)$.

Theo bổ đề 1, $\sigma$ cũng có thể apply cho $D_i$: $E_i = \sigma(D_i)$.

Do $D_i$ là `i-valent` nên $E_i$ cũng là `i-valent`.

Cũng theo bổ đề 1 ta có:

- $e(A) = e(\sigma(C_0)) = \sigma(e(C_0)) = \sigma(D_0)$ = `0-valent` (1)

- $e(e'(A)) = e(e'(\sigma(C_0))) = \sigma(e(e'(C_0))) = \sigma(e(C_1)) = \sigma(D_1)$ = `1-valent` (2)

Từ (1) và (2), ta thấy điều này là vô lý vì trái với giả thiết A là một `Deciding Run`.

![p2](https://i.imgur.com/6EUMXi3.png)

Do vậy, bất kể trường hợp nào ta cũng suy ra vô lý ta có đpcm.


### Chứng minh mệnh đề

Ta nhận thấy rằng với mọi *deciding run* từ một *bivalent* Configuration, sẽ phải tồn tại một Step mà ở đó Configuration sẽ được chuyển từ *bivalent* thành *univalent*. Và Step đó sẽ xác định giá trị cuối cùng mà các *process* đồng thuận với nhau. Điều ta cần chỉ ra ở đây là luôn tồn tại một chuỗi vô hạn các *event* mà chúng có thể tránh được sự chuyển giao này, từ đó tồn tại một *admissible run* nhưng không phải là *deciding run*.

Cái *admissible non-deciding run* sẽ được xây dựng bằng nhiều *giai đoạn - stage*. Bắt đầu với việc duy trì một cái queue cho mọi *process* bắt đầu với thứ tự ngẫu nhiên. Sắp xếp các *message* ở trong Message Buffer theo thứ tự thời gian gửi (*message* được gửi sớm hơn sẽ ở đầu).

Mỗi stage sẽ được chọn như sau:

- Bắt đầu với một *bivalent configuration* $C_0$ (tồn tại theo bổ đề 2)
- Chọn `e = (p,m)` là *mesage* được gửi sớm nhất trong Message Buffer (e có thể là $\phi$).
- Theo bổ đề 2, thì tồn tại một *bivalent* $C_1$ có thể *reachable* từ $C_0$ mà `e` là *event* được apply cuối cùng.
- Tương tự ta có thể lặp lại các bước kể trên, để tạo thành một `admissible run` mà không bao giờ dừng.

Ta có đpcm.
