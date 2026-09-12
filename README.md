# MiniWin Desktop OS

一个用 x86 汇编写的微型图形桌面操作系统。

![License](https://img.shields.io/badge/License-MIT-blue.svg)
![Assembly](https://img.shields.io/badge/Assembly-NASM-orange.svg)

---

## 功能

- 320×200 256色图形模式
- PS/2 鼠标驱动
- 十字光标 + 双缓冲
- 状态栏显示坐标
- ~45 FPS

---

## 文件结构

```
MiniWin/
├── bin/
│   ├── boot.bin          # 编译产物
│   ├── kernel.bin        # 编译产物
│   └── os.img            # 可启动镜像
├── src/
│   ├── boot.asm          # 引导扇区
│   ├── kernel.asm        # 内核入口（仅 %include "stage2.inc"）
│   └── stage2.inc        # 桌面系统实现
├── tools/
│   ├── build.sh          # 编译脚本 (Linux/WSL)
│   └── STARTOS.BAT       # 一键启动 (Windows)
├── LICENSE
└── README.md
```

---

## 编译运行

### Windows

双击 `tools/STARTOS.BAT`

> 前提：`bin/os.img` 已存在。首次使用请先在 Linux/WSL 下运行 `tools/build.sh`，或使用包内已附带的 `bin/os.img`。

### Linux/WSL

```bash
cd tools
chmod +x build.sh
./build.sh
```

脚本会自动编译、打包 `bin/os.img`，并询问是否立即启动 QEMU。

### 手动编译

```bash
nasm -f bin src/boot.asm -o bin/boot.bin
nasm -f bin -I src/ src/kernel.asm -o bin/kernel.bin

dd if=/dev/zero of=bin/os.img bs=512 count=2880
dd if=bin/boot.bin of=bin/os.img bs=512 count=1 conv=notrunc
dd if=bin/kernel.bin of=bin/os.img bs=512 seek=1 conv=notrunc

qemu-system-x86_64 -drive format=raw,file=bin/os.img
```

> 说明：`src/kernel.asm` 内容为 `%include "stage2.inc"`，NASM 会在汇编时把 `stage2.inc` 展开进去。由于 `stage2.inc` 与 `kernel.asm` 同在 `src/` 目录，编译时需要加 `-I src/` 指定 include 搜索路径。

---

## 依赖

- NASM
- QEMU (运行)
- dd / certutil (打包)

---

## 许可证

MIT License

Copyright (c) 2026 20260509 (SimpleTools studio)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.