COEN 241: HW3

Nisarg Bhalavat (W1649219)


Task 1
----------------------
Q1. What is the output of "nodes" and "net"?

A1.
mininet> nodes
available nodes are:
h1 h2 h3 h4 h5 h6 h7 h8 s1 s2 s3 s4 s5 s6 s7

mininet> net
h1 h1-eth0:s3-eth2
h2 h2-eth0:s3-eth3
h3 h3-eth0:s4-eth2
h4 h4-eth0:s4-eth3
h5 h5-eth0:s6-eth2
h6 h6-eth0:s6-eth3
h7 h7-eth0:s7-eth2
h8 h8-eth0:s7-eth3
s1 lo:  s1-eth1:s2-eth1 s1-eth2:s5-eth1
s2 lo:  s2-eth1:s1-eth1 s2-eth2:s3-eth1 s2-eth3:s4-eth1
s3 lo:  s3-eth1:s2-eth2 s3-eth2:h1-eth0 s3-eth3:h2-eth0
s4 lo:  s4-eth1:s2-eth3 s4-eth2:h3-eth0 s4-eth3:h4-eth0
s5 lo:  s5-eth1:s1-eth2 s5-eth2:s6-eth1 s5-eth3:s7-eth1
s6 lo:  s6-eth1:s5-eth2 s6-eth2:h5-eth0 s6-eth3:h6-eth0
s7 lo:  s7-eth1:s5-eth3 s7-eth2:h7-eth0 s7-eth3:h8-eth0

Q2. What is the output of "h7 ifconfig"?

A2.
mininet> h7 ifconfig
h7-eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.0.0.7  netmask 255.0.0.0  broadcast 10.255.255.255
        inet6 fe80::6043:dbff:fe3e:56fb  prefixlen 64  scopeid 0x20<link>
        ether 62:43:db:3e:56:fb  txqueuelen 1000  (Ethernet)
        RX packets 58  bytes 4504 (4.5 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 10  bytes 796 (796.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0



Task 2
----------------------
Q1. Draw the function call graph of this controller. For example, once a packet comes to the controller, which function is the first to be called, which one is the second, and so forth?

A1. The controller is working in 4 step method after starting the switch:
	1. Handling Packets
	2. Hub Module
	3. Resending the packet
	4. Send the message packet

	Function call graph:
	launch() -> _handle_PacketIn() -> act_like_hub() -> resend_packet() -> sending message to port


Q2. Have h1 ping h2, and h1 ping h8 for 100 times (e.g., h1 ping -c100 h2).
	a. How long does it take (on average) to ping for each case?
	b. What is the minimum and maximum ping you have observed?
	c. What is the difference, and why?

A2. 
mininet> h1 pings h2
--- 10.0.0.2 ping statistics ---
100 packets transmitted, 100 received, 0% packet loss, time 99279ms
rtt min/avg/max/mdev = 1.591/4.318/13.931/2.562 ms

mininet> h1 pings h8
--- 10.0.0.8 ping statistics ---
100 packets transmitted, 100 received, 0% packet loss, time 99223ms
rtt min/avg/max/mdev = 7.758/18.518/77.307/10.420 ms

	a. 
		Average for h1 pings h2  =  4.318 ms
		Average for h1 pings h8  = 18.518 ms
	
	b. 
		Min ping for h1 pings h2 =  1.591 ms
		Max ping for h1 pings h2 = 13.931 ms
		
		Min ping for h1 pings h8 =  7.758 ms
		Max ping for h1 pings h8 = 77.307 ms
	
	c. 
		On an average when h1 pings h2, it takes less time as compared to when h1 pings h8. This is due to multiple switches the packet needs to travel i.e. in first case h1 and h2 are connected via same switch s3. In second case, the h1 is not directly connected and have 5 switches before getting connected to h8. Hence, the difference of approx 14ms can be seen.

Q3. Run "iperf h1 h2" and "iperf h1 h8"
	a. What is "iperf" used for?
	b. What is the throughput for each case?
	c. What is the difference, and explain the reasons for the difference.

A3. 
	a. 
		Iperf is an utility tool for monitoring and fine-tuning network performance. It is an open-source program that can generate consistent performance statistics for any network.
	
	b. 
		mininet> iperf h1 h2
		*** Iperf: testing TCP bandwidth between h1 and h2 
		*** Results: ['4.21 Mbits/sec', '4.92 Mbits/sec']

		mininet> iperf h1 h8
		*** Iperf: testing TCP bandwidth between h1 and h8 
		*** Results: ['2.30 Mbits/sec', '2.81 Mbits/sec']
	
	c.
		We can see from above results that the throughput is higher in first case and lower in second, it is due to multiple switches which is causing network congestion.

Q4. Which of the switches observe traffic? Please describe your way for observing such traffic on switches (e.g., adding some functions in the "of_tutorial" controller).

A4. 
We can below line of code to the function _handle_PacketIn as its an event listener. When the packets are flooded, switches view the traffic and hence call the function.

log.info("Logging of Switch Traffic: %s " % (self.connection))



Task 3
----------------------
Q1. Describe how the above code works, such as how the "MAC to Port" map is established. You could use a 'ping' example to describe the establishment process (e.g., h1 ping h2).
A1.
Here, as we know that "mac_to_port" creates a mapping of destination MAC addresses with the network ports once it is discovered by the controller. So, initially the controller floods the packet on the entire network, and as the MAC is discovered, the values are stored so that next time packet comes for same destination, it doesn't need to flood the entire network.


Q2. Have h1 ping h2, and h1 ping h8 for 100 times (e.g., h1 ping -c100 p2).
	a. How long did it take (on average) to ping for each case?
	b. What is the minimum and maximum ping you have observed?
	c. Any difference from Task 2 and why do you think there is a change if there is?

A2.
--- 10.0.0.2 ping statistics ---
100 packets transmitted, 100 received, 0% packet loss, time 99232ms
rtt min/avg/max/mdev = 1.639/2.744/13.147/1.480 ms

--- 10.0.0.8 ping statistics ---
100 packets transmitted, 100 received, 0% packet loss, time 99218ms
rtt min/avg/max/mdev = 8.010/19.579/62.832/12.317 ms


	a. 
		Average for h1 pings h2  =  2.744 ms
		Average for h1 pings h8  = 19.579 ms
	
	b. 
		Min ping for h1 pings h2 =  1.639 ms
		Max ping for h1 pings h2 = 13.147 ms
		
		Min ping for h1 pings h8 =  8.010 ms
		Max ping for h1 pings h8 = 62.832 ms
	
	c. 
		If we check with task 2, the value for h1 pings h2 and h1 pings h8, there is no significant time difference, although the time taken by second case is lesser since the switch is not flooding every other nodes, instead it learns where the host is located and send packets directly. The destination MAC addresses are storred in "mac_to_port" list variable which reduces network congestion.


Q.3 Run "iperf h1 h2" and "iperf h1 h8".
	a. What is the throughput for each case?
	b. What is the difference from Task 2 and why do you think there is a change if there is?
	
A3. 
	a. 
		mininet> iperf h1 h2
		*** Iperf: testing TCP bandwidth between h1 and h2 
		*** Results: ['25.55 Mbits/sec', '31.39 Mbits/sec']
		
		mininet> iperf h1 h8
		*** Iperf: testing TCP bandwidth between h1 and h8 
		*** Results: ['10.20 Mbits/sec', '10.94 Mbits/sec']
		
	b.
		We can see that the throughput for Task 3 is much more than Task 2 for both the cases. We can see this as the switch now knows the destination MAC addresses which reduces the network congestion by not flooding all the network ports and hosts. We can also see that there is almost 4 times the throughput then Task 2.
