# SnapSurface

The SnapSurface component allows for the creation of SnapSurface objects. Nearby dragged objects will snap to a snap surface at the closest location on the surface.

## Usage

To create a SnapSurface object, add a SnapSurface component to any node that uses collisions. 

## Behavior

When the mouse ray intersects with the SnapSurface object while dragging, the dragged object is snapped to it. This causes it to reparent itself to whatever node you have attached the SnapSurface component to. The dragged object will move to the point of intersection and its normal will be changed to match the surface normal.

When the mouse ray is moved off of the SnapSurface object while dragging, the dragged object is unsnapped and retains its original transform.

A SnapSurface object can have unlimited [Draggable](./Draggable.md) objects attached.

## Signals

No signals emitted at the moment.

## Possible User Pitfalls

Ensure no unintended behavior arises from the reparenting feature, as Draggable objects will be added and removed from the SnapSurface object's children.

Ensure no unintended behavior arises from changing the Draggable object's transform.