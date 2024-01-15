# SnapPoint

The SnapPoint component allows for the creation of SnapPoint objects. Dragged objects will snap to nearby snap points.

## Usage

To create a SnapPoint object, add a SnapPoint component as a direct child to any Node. Define Snap Shape as desired. This is the area that will be used to determine when a [Draggable](./Draggable.md) object should snap.

## Behavior

When the mouse ray enters the SnapPoint object's area while dragging, the dragged object is snapped to it. This causes it to reparent itself to whatever node you have attached the SnapPoint component to. It will also copy the transform of the snap point.

When the mouse ray is moved outside of the SnapPoint object's area while dragging, the dragged object is unsnapped and retains its original transform.

A SnapPoint object can only have one Draggable object snapped to it at a time.

## Signals

No signals emitted at the moment.

## Possible User Pitfalls

Ensure no unintended behavior arises from the reparenting feature, as Draggable objects will be added and removed from the SnapPoint object's children.

Ensure no unintended behavior arises from changing the Draggable object's transform.
