
////server setup
(
s.options.numWireBufs = 1024*16;
s.options.numOutputBusChannels=4;
s.options.numInputBusChannels=0;
TempoClock.default.tempo_(120/60);
s.options.memSize = 8192*64;
//s.options.blockSize = 64/4;
s.options.maxNodes = 1024 * 64;
s.waitForBoot
)

/////wavetables
Buffer.freeAll
(
~w= Buffer.alloc(s,2048);
~t= Buffer.alloc(s,2048);
)

(
var env,sig,wt,angle=0,level,levels;

~levels=360.collect{

	level=exp(Complex(0,1)*angle).imag;
		angle=angle+1.degrad;
	levels=level.rrand(exp(Complex(0,1)*angle+((1/3)/1.6180339887499)).imag);
};
env = Env(~levels,[1]);
sig=env.asSignal(1024);
wt = sig.asWavetable;
~w.loadCollection(wt);
sig.plot;
)

(
var signal,wt,m=1,amp;

~level=360.collect{m=m+1;amp=m.reciprocal};
signal=Signal.sineFill(1024,~level,[0]);

wt = signal.asWavetable;
~w.loadCollection(wt);
signal.plot;
)


////speaker setup
(
// 3D
~a = VBAPSpeakerArray.new(3, [[0, 45], [180, 45], [90, 45.neg], [90.neg, 45.neg]]);
~b = Buffer.loadCollection(s, ~a.getSetsAndMatrices);
)

(
// 3D random
~a = VBAPSpeakerArray.new(3, [[180.rand2, 90.rand2], [180.rand2, 90.rand2], [180.rand2, 90.rand2], [180.rand2, 90.rand2]]);
~b = Buffer.loadCollection(s, ~a.getSetsAndMatrices);
)

/////synths
(
(
SynthDef.new(\ob, {
	var n1=0,cutt=1200,az=0,el=0,mag=1;
	var phase,scale=1,pl=0,osc;
	var freq, env,m=1,bank,pitch,fund=55, angle=0,rad;
	var wrappedOut1 = { |busArray, signalArray|
	[busArray, signalArray].flop.do { |pair|
		Out.ar(pair[0], pair[1])}};
var out = NamedControl.kr(\out, [0, 1, 2, 3]);  // multiple buses!

bank=100;
pitch=2.pow(n1/(2*6));
freq=(fund*scale)*pitch;

bank.do{
phase=exp(Complex(0,1)*angle.degrad).theta;
angle=(angle+(360-(360/1.6180339887499))).wrap(0,360);

env=EnvGen.ar(Env([1,2],[360]),doneAction:2,levelScale:pitch.reciprocal);

osc=VBAP.ar(4,
Osc.ar(~w,(freq*m),
mul:SinOsc.ar(~magx.[pl].reciprocal,phase,mul:~magx.[pl],add:1),
phase:SinOsc.ar(~magx.[pl],phase)),
~b.bufnum,
SinOsc.ar(1/3,phase:~az.[pl].linlin(pi.neg,pi,2pi.neg,2pi),mul:180),
SinOsc.ar(1/3,phase:~el.[pl].linlin((pi/2).neg,(pi/2),2pi.neg,2pi),mul:90)
		);
m=m+1;
pl=pl+1;

//wrappedOut1.value(out,LPF.ar(LeakDC.ar((osc)*env*0.1),cutt))
		Out.ar(0,LPF.ar(LeakDC.ar((osc)*env*0.1),cutt,m.reciprocal));
	};
}).add;
);
(
SynthDef.new(\oc, {
	var n1=0,cutt=1200,az=0,el=0,mag=1;
	var phase,scale=1,pl=0,osc;
	var freq, env,m=1,bank,pitch,fund=55, angle=0,rad;
	var wrappedOut1 = { |busArray, signalArray|
	[busArray, signalArray].flop.do { |pair|
		Out.ar(pair[0], pair[1])}};
var out = NamedControl.kr(\out, [0, 1, 2, 3]);  // multiple buses!

bank=100;
pitch=2.pow(n1/(2*6));
freq=(fund*scale)*pitch;

bank.do{
phase=exp(Complex(0,1)*angle.degrad).theta;
angle=(angle+(360-(360/1.6180339887499))).wrap(0,360);

env=EnvGen.ar(Env([1,2],[360]),doneAction:2,levelScale:pitch.reciprocal);

osc=VBAP.ar(4,
Osc.ar(~w,(freq*m),
mul:SinOsc.ar(~magx.[pl].reciprocal,phase,mul:~magx.[pl],add:1),
phase:SinOsc.ar(~magx.[pl],phase)),
~b.bufnum,
SinOsc.ar(1/3,phase:~az.[pl].linlin(pi.neg,pi,2pi.neg,2pi),mul:180),
SinOsc.ar(1/3,phase:~el.[pl].linlin((pi/2).neg,(pi/2),2pi.neg,2pi),mul:90)
		);
m=m+1;
pl=pl+1;

//wrappedOut1.value(out,LPF.ar(LeakDC.ar((osc)*env*0.1),cutt))
		Out.ar(0,LPF.ar(LeakDC.ar((osc)*env*0.1),cutt,m.reciprocal));
	};
}).add;
);
(
SynthDef.new(\od, {
	var n1=0,cutt=1200,az=0,el=0,mag=1;
	var phase,scale=1,pl=0,osc;
	var freq, env,m=1,bank,pitch,fund=55, angle=0,rad;
	var wrappedOut1 = { |busArray, signalArray|
	[busArray, signalArray].flop.do { |pair|
		Out.ar(pair[0], pair[1])}};
var out = NamedControl.kr(\out, [0, 1, 2, 3]);  // multiple buses!

bank=100;
pitch=2.pow(n1/(2*6));
freq=(fund*scale)*pitch;

bank.do{
phase=exp(Complex(0,1)*angle.degrad).theta;
angle=(angle+(360-(360/1.6180339887499))).wrap(0,360);

env=EnvGen.ar(Env([1,2],[360]),doneAction:2,levelScale:pitch.reciprocal);

osc=VBAP.ar(4,
Osc.ar(~w,(freq*m),
mul:SinOsc.ar(~magx.[pl].reciprocal,phase,mul:~magx.[pl],add:1),
phase:SinOsc.ar(~magx.[pl],phase)),
~b.bufnum,
SinOsc.ar(1/3,phase:~az.[pl].linlin(pi.neg,pi,2pi.neg,2pi),mul:180),
SinOsc.ar(1/3,phase:~el.[pl].linlin((pi/2).neg,(pi/2),2pi.neg,2pi),mul:90)
		);
m=m+1;
pl=pl+1;

//wrappedOut1.value(out,LPF.ar(LeakDC.ar((osc)*env*0.1),cutt))
		Out.ar(0,LPF.ar(LeakDC.ar((osc)*env*0.1),cutt,m.reciprocal));
	};
}).add;
)

)

(Synth(\ob);Synth(\oc);Synth(\od);)
//////////arrays
(
~time=2;
(
var  sph1,sph2,m_x=1,m_y=1,m_z=1,az1=0,el1=0,az2=0,el2=0,mag_x,mag_y,mag_z;
var azx=0,elx=0,azy=0,ely=0,azz=0,elz=0,sphx,sphy,sphz,rad=1;

~az = (360*~time).collect{

		az1=(az1+(1)).wrap(180.neg,180);

	el1=(el1+(360-(360/1.6180339887499))).wrap(90.neg,90);

	sph1=Spherical(1,az1.degrad,el1.degrad).theta.round(0.00001);

	};

~el = (360*~time).collect{

		az2=(az2+(1)).wrap(180.neg,180);

	el2=(el2+(360-(360/1.6180339887499))).wrap(90.neg,90);

	sph2=Spherical(1,az2.degrad,el2.degrad).phi.round(0.00001);

	};

~magx = (360*~time).collect{

	azx=(azx+(1)).wrap(180.neg,180);

	elx=(elx+(360-(360/1.6180339887499))).wrap(90.neg,90);

	sphx=Spherical(rad,azx.degrad,elx.degrad);

	mag_x=(Complex(cos((sphx.theta.round(0.00001)*m_x).wrap(pi.neg,pi)),cos((sphx.theta.round(0.00001)*m_x).wrap(pi.neg,pi))).rho*
	Complex(cos((sphx.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sphx.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho)*sphx.rho;

//mag_x=(Complex(cos((sphx.theta.round(0.00001)*m_x).wrap(pi.neg,pi)),cos((sphx.theta.round(0.00001)*m_x).wrap(pi.neg,pi))).rho*
//Complex(sin((sphx.phi.round(0.00001)*(m_x-1)).wrap((pi/2).neg,(pi/2))),sin((sphx.phi.round(0.00001)*(m_x-1)).wrap((pi/2).neg,(pi/2)))).rho*
//Complex(cos((sphx.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sphx.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho)*sphx.rho;

	mag_x=mag_x/(2.sqrt);
	};

~magy = (360*~time).collect{

	azy=(azy+(1)).wrap(180.neg,180);

	ely=(ely+(360-(360/1.6180339887499))).wrap(90.neg,90);

	sphy=Spherical(rad,azy.degrad,ely.degrad);

	mag_y=(Complex(sin((sphy.theta.round(0.00001)*m_y).wrap(pi.neg,pi)),sin((sphy.theta.round(0.00001)*m_y).wrap(pi.neg,pi))).rho*
		Complex(cos((sphy.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sphy.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho)*sphy.rho;

//	mag_y=(Complex(sin((sphy.theta.round(0.00001)*m_y).wrap(pi.neg,pi)),sin((sphy.theta.round(0.00001)*m_y).wrap(pi.neg,pi))).rho*
//Complex(sin((sphy.phi.round(0.00001)*(m_y-1)).wrap((pi/2).neg,(pi/2))),sin((sphy.phi.round(0.00001)*(m_y-1)).wrap((pi/2).neg,(pi/2)))).rho*
//Complex(cos((sphy.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sphy.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho)*sphy.rho;

mag_y=mag_y/(2.sqrt);
	};

~magz = (360*~time).collect{

	azz=(azz+(1)).wrap(180.neg,180);

	elz=(elz+(360-(360/1.6180339887499))).wrap(90.neg,90);

	sphz=Spherical(rad,azz.degrad,elz.degrad);

if(
m_z.even,
mag_z=Complex(cos((sphz.phi.round(0.00001)*m_z).wrap((pi/2).neg,(pi/2))),cos((sphz.phi.round(0.00001)*m_z).wrap((pi/2).neg,(pi/2)))).rho*sphz.rho,
mag_z=Complex(sin((sphz.phi.round(0.00001)*m_z).wrap((pi/2).neg,(pi/2))),sin((sphz.phi.round(0.00001)*m_z).wrap((pi/2).neg,(pi/2)))).rho*sphz.rho
	);
	mag_z=mag_z/(2.sqrt);
	};

)

////////////////////////

(
var dur=1,ph1,ph2,ph3,pl1=0,pl2=0,pl3=0,pl4=0,pl5=0,pl6=0,sph1,sph2,sph3,n1,n2,n3,mult=6;
var mag1,mag2,mag3;

~phase2 = (360*~time).collect{
	ph1=~magx.[pl1];
	pl1=pl1+1;
	ph1=(ph1/dur).round(0.000001);
	};

~phase3 = (360*~time).collect{
	ph2=~magy.[pl2];
	pl2=pl2+1;
	ph2=(ph2/dur).round(0.000001);
	};

~phase4 = (360*~time).collect{
	ph3=~magz.[pl3];
	pl3=pl3+1;
	ph3=(ph3/dur).round(0.000001);
	};

~n2 = 100.collect{
	mag1=Cartesian(~magx[pl4],~magy[pl4],~magz[pl4]).rho;
	sph1=Spherical(mag1,~az.[pl4],~el.[pl4]).x;
	//sph1=~magx.[pl4];
	pl4=pl4+1;
	n1=(sph1*mult).round(1);
	};

~n3 = 100.collect{
	mag2=Cartesian(~magx[pl5],~magy[pl5],~magz[pl5]).rho;
	sph2=Spherical(mag2,~az.[pl5],~el.[pl5]).y;
	//sph2=~magy.[pl5];
	pl5=pl5+1;
	n2=(sph2*mult).round(1);
	};

~n4 = 100.collect{
	mag3=Cartesian(~magx[pl6],~magy[pl6],~magz[pl6]).rho;
	sph3=Spherical(mag3,~az.[pl6],~el.[pl6]).z;
	//sph3=~magz.[pl6];
	pl6=pl6+1;
	n3=(sph3*mult).round(1);
	};

)

)
s.record(numChannels:4)