# CAD Grid System ABC & 123 (Hệ Lưới Trục AutoCAD)

Dự án cung cấp bộ công cụ và bản vẽ mẫu để tạo hệ thống lưới trục tọa độ chuẩn trong AutoCAD với các trục chữ cái **A - B - C** và chữ số **1 - 2 - 3**, tuân thủ tiêu chuẩn thiết kế kiến trúc và kết cấu xây dựng (TCVN).

---

## 📦 Nội dung dự án

| Tên File | Loại | Mô tả |
| :--- | :--- | :--- |
| **`luoi_truc_123_ABC.dxf`** | Bản vẽ CAD | Bản vẽ chuẩn: Trục đứng `1-2-3`, Trục ngang `A-B-C`. Mở được trên mọi CAD. |
| **`luoi_truc_ABC_123.dxf`** | Bản vẽ CAD | Biến thể: Trục đứng `A-B-C`, Trục ngang `1-2-3`. |
| **`VeLuoiTruc.lsp`** | AutoLISP | Lisp tự động vẽ lưới trục với kích thước và điểm đặt tùy chọn (`LT` hoặc `VELUOI`). |
| **`VeLuoiTruc.scr`** | AutoCAD Script | File script vẽ tự động bằng thao tác kéo thả vào AutoCAD. |
| **`generate_cad.ps1`** | PowerShell | Script sinh file DXF định dạng ASCII R12 tiêu chuẩn. |
| **`HUONG_DAN_SU_DUNG.md`** | Hướng dẫn | Hướng dẫn sử dụng chi tiết bằng tiếng Việt. |

---

## 🎨 Quy chuẩn Layer trong bản vẽ

| Layer | Màu sắc | Kiểu đường | Mục đích |
| :--- | :--- | :--- | :--- |
| `TRUC` | Đỏ (1) | `CENTER` | Tim trục công trình |
| `BONG_BONG` | Vàng (2) | `Continuous` | Vòng tròn ký hiệu đầu trục ($R = 450\text{mm}$) |
| `TEXT_TRUC` | Xanh lá (3) | `Continuous` | Tên trục A, B, C, 1, 2, 3 căn giữa ($H = 400\text{mm}$) |
| `DIM` | Xanh lơ (4) | `Continuous` | Đường gióng và số đo kích thước nhịp |

---

## 🚀 Hướng dẫn sử dụng

### 1. Mở trực tiếp (Nhanh nhất)
* Khởi động AutoCAD, chọn **Open** (`Ctrl + O`).
* Chọn loại file `DXF (*.dxf)`.
* Mở file `luoi_truc_123_ABC.dxf` và gõ lệnh `Z` $\rightarrow$ `E` để xem toàn bộ bản vẽ.

### 2. Kéo thả file Script
* Kéo trực tiếp file `VeLuoiTruc.scr` thả vào màn hình AutoCAD đang mở.

### 3. Dùng AutoLISP tùy biến kích thước
* Gõ lệnh `APPLOAD` trong AutoCAD, chọn load file `VeLuoiTruc.lsp`.
* Gõ lệnh:
  ```text
  LT
  ```
* Chọn điểm đặt và nhập kích thước các nhịp $X, Y$ theo mong muốn.

---

## 📄 Bản quyền
Dự án được phân phối dưới giấy phép [MIT License](LICENSE).
