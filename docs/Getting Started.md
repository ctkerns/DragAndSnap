# Getting Started

### Components

Drag and Snap uses a Component design pattern. The functionality of this plugin is not implemented through standalone nodes. Instead, a number of components are supported that when attached as children to the appropriate node, their behavior changes, offering the desired functionality.

Visit the documenation page for each of these components to understand their usage.

| Component | Inherits: | Attach to: |
| --- | --- | --- |
| [Draggable](./Draggable.md) | Node | Any CollisionObject3D | 
| [SnapPoint](./SnapPoint.md) | Area3D | Any Node |
| [SnapSurface](./SnapSurface.md) | Node | Any node with collisions |