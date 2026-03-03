# Car Dashboard Speedometer

A modern, high-performance car speedometer built with **Qt 6 and QML**. This project demonstrates a custom UI with interactive physics, smooth animations, and a responsive design.

## Project Overview

The **Car Dashboard Speedometer** is an interactive automotive dashboard component. It features a custom-styled dial with a dynamic red needle, a digital speed readout, and a "high-speed" warning system that turns the readout red at speeds over 120 km/h.

### Key Features

- **High Performance**: Runs at a smooth 60 FPS for instant visual feedback.
- **Interactive Physics**: Realistic acceleration, braking, and coasting simulation.
- **Custom Styling**: Fully customized QML `Dial` with `Canvas` drawing and `Repeater` for ticks and labels.
- **Responsive Design**: Built using QML's declarative syntax, making it easy to adapt to different screen sizes.
- **Dynamic UI**: The interface reacts to user input and speed changes (e.g., color shifts at high speeds).

## Visual Showcase

Below is a gallery of the speedometer at various speed levels:

|          **Speed Level 1**           |          **Speed Level 2**           |          **Speed Level 3**           |          **Speed Level 4**           |
| :----------------------------------: | :----------------------------------: | :----------------------------------: | :----------------------------------: |
| ![Speed Level 1](Images/meter_1.png) | ![Speed Level 2](Images/meter_2.png) | ![Speed Level 3](Images/meter_3.png) | ![Speed Level 4](Images/meter_4.png) |

## Controls

The speedometer is fully interactive via keyboard input:

| Key          | Action         | Description                                      |
| :----------- | :------------- | :----------------------------------------------- |
| `Up Arrow`   | **Accelerate** | Increases the speed gradually up to 180 km/h.    |
| `Down Arrow` | **Brake**      | Decreases the speed quickly.                     |
| (None)       | **Coast**      | Slowly decreases speed when no keys are pressed. |

## Technical Implementation

- **QML & QtQuick**: Used for the entire UI layout and rendering.
- **Dial Component**: Heavily customized background and handle (needle) to achieve a professional automotive look.
- **Canvas API**: Used for drawing the dynamic speed arc and high-speed warning indicators.
- **Timer Engine**: A high-frequency timer drives the physics and ensures smooth animations.

## Getting Started

### Prerequisites

- Qt 6.x (Recommended)
- CMake
- C++ Compiler (GCC/Clang/MSVC)

### Build Instructions

1.  Open the project in **Qt Creator**.
2.  Configure the project using a **Qt 6 Kit**.
3.  Build and Run.

---

_Created by [aaabdelaziz](https://github.com/aaabdelaziz)_
