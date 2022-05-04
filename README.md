# Dyanmic COM Balancing
 
 What is this repository?
 
This is a MATLAB simulation to learn how to balance several well-known mechanical systems such as inverted pendulum, double, inverted pendulum, unicycle, pendulum, and more. This made by a few people and not limited to M. P. Deisenroth, D. Fox, and C. E. Rasmussen. 

The benefit of using PILCO is that the machine learning method they used is derivation of the Gaussian process and can learn an arbitrary latent function quickly and accurately. An inverted pendulum can approximately simulate a biped’s “balance” using its COG. If the COG is too far outside the boundaries, then the biped will fall. Thus, simulation of inverted pendulum is a useful start to balance biped robots.

The contribution I have put towards this work is to learn the motion of one pendulum given a trigonometric arbitrary motion. For example, you would take your favorite sin or cos function as the method to describe the motion of the demonstrator pendulum then take the derivative of the motion function to find the velocity. And the second pendulum will learn that arbitrary motion the user has inputted. 

This project is a part of my other repository Human-Robot-motion-transfer-for-complete-body-control. But the issue is mimicry of two bipeds with different COM. What might be stable motions for the human demonstrator may not be stable for the NAO robot. Thus, PILCO will assist in this regard by learning what are stable motions for the NAO robot.

The challenge to make this useful for the application of balancing biped robots is there must be a loss function introduced to learn a stable motion. Rudimentary loss functions were defined one as the “ZMP” zero-point movement and another as mimic the demonstrator’s movements as close as possible. Fine tuning between the two is the programmer’s job. 

 The loss functions that were used saturated loss and double hinge loss.  Saturated loss is used to penalize differential between the demonstrator’s COM vs what is trying to be learned. The double hinge loss is to penalize unstable motions aka the ZMP. More detials given in my thesis below.

 
Gaussian Processes for Data-Efficient Learning in Robotics and Control

http://mlg.eng.cam.ac.uk/pilco/


Beginners Guide to Learn about PILCO and Gaussian Process

https://tingq111011.medium.com/pilco-explanation-ef5b69f6349f

To learn about Kernels and how they are important for Machine Learning
https://www.cs.toronto.edu/~duvenaud/cookbook/

My Thesis which involves both Human-Robot-motion-trasnfer-for-complete-body-control repository and Dynamic-COM-Balance 
https://rc.library.uta.edu/uta-ir/bitstream/handle/10106/30244/VILLA-THESIS-2021.pdf?sequence=1&isAllowed=y


How to setup?

1) Download MATLAB and this repository. 
2) Open project -> PILCO\scenarios\Balance COM
3) Hit play/run
