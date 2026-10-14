# HƯỚNG DẪN SỬ DỤNG BẢN VẼ VÀ CÔNG CỤ LƯỚI TRỤC CAD (ABC & 123)

Thư mục đã được tạo đầy đủ các định dạng bản vẽ và công cụ để bạn có thể mở và sử dụng ngay lập tức trên mọi phiên bản AutoCAD (từ AutoCAD 2007 đến AutoCAD 2026, AutoCAD LT, ZWCAD, GstarCAD, v.v.).

---

## 📁 Danh Sách Các File Trong Thư Mục

| Tên File | Định Dạng | Mô Tả |
| :--- | :--- | :--- |
| **`luoi_truc_123_ABC.dxf`** | Bản vẽ CAD (DXF) | **Chuẩn TCVN**: Trục đứng `1-2-3`, trục ngang `A-B-C`. Mở trực tiếp trong AutoCAD. |
| **`luoi_truc_ABC_123.dxf`** | Bản vẽ CAD (DXF) | **Biến thể**: Trục đứng `A-B-C`, trục ngang `1-2-3`. Mở trực tiếp trong AutoCAD. |
| **`VeLuoiTruc.lsp`** | AutoLISP | Lisp CAD tự động tạo lưới trục với kích thước và điểm đặt tùy ý (Lệnh: `LT` hoặc `VELUOI`). |
| **`VeLuoiTruc.scr`** | AutoCAD Script | File kịch bản vẽ tự động - chỉ cần kéo thả vào màn hình CAD. |
| **`generate_cad.ps1`** | PowerShell Script | Script tạo lại các file DXF khi cần. |

---

## 🚀 3 Cách Sử Dụng Thuận Tiện Nhất

### Cách 1: Mở trực tiếp file bản vẽ DXF (Nhanh nhất)
1. Khởi động phần mềm **AutoCAD**.
2. Chọn menu **File** $\rightarrow$ **Open** (hoặc nhấn phím tắt `Ctrl + O`).
3. Ở ô **Files of type**, chọn `DXF (*.dxf)`.
4. Chọn file **[luoi_truc_123_ABC.dxf](file:///c:/Users/huuki/Desktop/LV%20autocad/luoi_truc_123_ABC.dxf)** hoặc **[luoi_truc_ABC_123.dxf](file:///c:/Users/huuki/Desktop/LV%20autocad/luoi_truc_ABC_123.dxf)** và nhấn **Open**.
5. Gõ lệnh `Z` $\rightarrow$ Enter $\rightarrow$ `E` $\rightarrow$ Enter (`Zoom Extents`) để hiển thị toàn bộ bản vẽ.
6. Bạn có thể lưu lại thành file `.dwg` bằng lệnh `Save As` (`Ctrl + Shift + S`).

---

### Cách 2: Kéo thả file Script `.scr` vào bản vẽ đang mở
1. Mở bất kỳ bản vẽ AutoCAD nào của bạn.
2. Mở thư mục chứa file, dùng chuột kéo file **[VeLuoiTruc.scr](file:///c:/Users/huuki/Desktop/LV%20autocad/VeLuoiTruc.scr)** thả trực tiếp vào vùng vẽ AutoCAD.
3. AutoCAD sẽ tự động tạo Layer, vẽ các trục, bong bóng ký hiệu và đo kích thước tự động trong tích tắc!

---

### Cách 3: Dùng AutoLISP để vẽ lưới trục theo kích thước tùy chỉnh (`VeLuoiTruc.lsp`)
Nếu bạn muốn nhập kích thước các nhịp tùy ý (ví dụ: nhịp 4m, 5m, 6m...):
1. Trong AutoCAD, gõ lệnh `APPLOAD` $\rightarrow$ Enter.
2. Chọn file **[VeLuoiTruc.lsp](file:///c:/Users/huuki/Desktop/LV%20autocad/VeLuoiTruc.lsp)** $\rightarrow$ nhấn **Load**.
3. Ra ngoài màn hình vẽ, gõ lệnh:
   ```
   LT
   ```
   *(hoặc lệnh `VELUOI`)*
4. Làm theo các bước hướng dẫn trên dòng nhắc lệnh (Command Line):
   - **Chọn điểm gốc đặt lưới**: Click chọn 1 điểm trên màn hình (hoặc nhấn Enter để lấy gốc tọa độ `0,0,0`).
   - **Chọn kiểu trục**:
     - `1`: Trục đứng 1-2-3 / Trục ngang A-B-C (Mặc định).
     - `2`: Trục đứng A-B-C / Trục ngang 1-2-3.
   - **Khoảng cách nhịp X1, X2**: Nhập kích thước (mặc định 4000, 4500 mm).
   - **Khoảng cách nhịp Y1, Y2**: Nhập kích thước (mặc định 4000, 4000 mm).
5. Chương trình sẽ tự động vẽ hoàn chỉnh lưới trục và đường kích thước theo đúng ý bạn!

---

## 🎨 Quy Chuẩn Lớp (Layer) & Nét Vẽ

Bản vẽ tuân thủ theo tiêu chuẩn kỹ thuật thiết kế xây dựng / kiến trúc:

| Tên Layer | Màu sắc | Kiểu nét (Linetype) | Công dụng |
| :--- | :--- | :--- | :--- |
| **`TRUC`** | Đỏ (Color 1 - Red) | `CENTER` (Gạch chấm) | Tim trục định vị công trình |
| **`BONG_BONG`** | Vàng (Color 2 - Yellow) | `Continuous` | Vòng tròn ký hiệu đầu trục (R = 450mm) |
| **`TEXT_TRUC`** | Xanh lá (Color 3 - Green) | `Continuous` | Chữ cái A, B, C và số 1, 2, 3 căn giữa |
| **`DIM`** | Xanh lơ (Color 4 - Cyan) | `Continuous` | Đường kích thước nhịp và tổng chiều dài |

---

## 📐 Thông Số Kích Thước Mặc Định (Tỷ lệ 1:100)
- **Phương ngang (X)**: Nhịp 1-2 = `4000 mm`, Nhịp 2-3 = `4500 mm` (Tổng: `8500 mm`).
- **Phương dọc (Y)**: Nhịp A-B = `4000 mm`, Nhịp B-C = `4000 mm` (Tổng: `8000 mm`).
- **Bán kính bong bóng trục**: `R = 450 mm`.
- **Chiều cao chữ tên trục**: `H = 400 mm`.
- **Độ vươn đầu trục**: `1200 mm` qua giao điểm trục ngoài cùng.
