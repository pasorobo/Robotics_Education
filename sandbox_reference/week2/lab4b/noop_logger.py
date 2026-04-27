#!/usr/bin/env python3
"""
no-op adapter logger.
Does not implement IK. Does not parse URDF. Does not generate trajectory.
Does not control the robot. Subscribes /joint_states and prints INFO log only.
"""
import rclpy
from rclpy.node import Node
from sensor_msgs.msg import JointState


class NoopLogger(Node):
    def __init__(self):
        super().__init__('noop_logger')
        self.sub = self.create_subscription(
            JointState, '/joint_states', self.cb, 10)
        self.get_logger().info('noop_logger started, subscribing /joint_states')

    def cb(self, msg: JointState):
        names = list(msg.name)
        positions = [round(p, 4) for p in msg.position]
        ts = msg.header.stamp.sec
        self.get_logger().info(f'recv name={names} pos={positions} ts={ts}')


def main():
    rclpy.init()
    node = NoopLogger()
    try:
        rclpy.spin(node)
    except KeyboardInterrupt:
        pass
    finally:
        node.destroy_node()
        rclpy.shutdown()


if __name__ == '__main__':
    main()
