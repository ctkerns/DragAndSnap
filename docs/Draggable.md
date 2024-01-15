# Draggable

The Draggable component allows for the creation of a Draggable object. A Draggable object can be clicked and dragged around in 3D space using the mouse.

## Usage

To create a Draggable object, add a Draggable component as a direct child to any CollisionObject3D.

## Behavior

Only one Draggable object will be dragged at a time. The position of the object will follow a vertical plane at distance from the camera where the object was originally selected.

When a Draggable object is snapped to a [SnapPoint](./SnapPoint.md) object or a [SnapSurface](./SnapSurface.md) object, it is reparented to that object.

## Signals

No signals emitted at the moment.

## Possible User Pitfalls

Do not rename the Draggable component at any point. It must be named "Draggable" for it to work.

Ensure that the CollisionObject3D you construct a Draggable object out of will not break anything if it is reparented, because it will be reparented by snapping.