
(
s.options.numWireBufs = 1024*16;
s.options.numOutputBusChannels=4;
s.options.numInputBusChannels=0;
TempoClock.default.tempo_(120/120);
s.options.memSize = 8192*64;
//s.options.blockSize = 64/4;
s.options.maxNodes = 1024 * 64;
s.waitForBoot
)

//////////phase shift
~c1 = Buffer.readChannel(s,,channels:0 );
(
(
SynthDef("help-phaseShift", { arg out=0;
        var in, chain;
        in = PlayBuf.ar(1, ~c1.bufnum, BufRateScale.kr(~c1), loop: 0);
        chain = FFT(LocalBuf(2048), in);
        chain = PV_PhaseShift(chain,90.degrad);
        Out.ar(out, 0.1 * IFFT(chain));
}).play(s);
);
)

/////////////////////buffers

~bl = Buffer.readChannel(s,,channels:0 );
~br = Buffer.readChannel(s,,channels:0 );

/////wavetables
Buffer.freeAll
(
~t= Buffer.alloc(s,2048);
)

(
var signal,wt,m=0,amp;

~level=360.collect{m=m+1;amp=m.reciprocal};
~phase=360.collect{pi};
signal=Signal.sineFill(1024,~level,~phase);

wt = signal.asWavetable;
~t.loadCollection(wt);
signal.plot;
)
//////////////////arrays
(
~time=1;
(
var  sph1,sph2,m_x=2,m_y=2,m_z=2,az1=0,el1=0,az2=0,el2=0,mag_x,mag_y,mag_z;
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

////////////////////////az

(
var pl1=0,az1,el1,sph1,rot1,i1,j1,k1,q1,raz1,rel1;
var pl2=0,az2,el2,sph2,rot2,i2,j2,k2,q2,raz2,rel2;
var pl3=0,az3,el3,sph3,rot3,i3,j3,k3,q3,raz3,rel3;
var r1=[0,0,1],r2=[0,0,1],r3=[0,0,1];
var v1=Quaternion(0,r1.[0],r1.[1],r1.[2]),v2=Quaternion(0,r2.[0],r2.[1],r2.[2]),v3=Quaternion(0,r3.[0],r3.[1],r3.[2]);
var angle=(360-(360/1.6180339887499));

~az_x=(360*~time).collect{

	az1=~az.[pl1];el1=~el.[pl1];
	pl1=pl1+1;
sph1=Spherical(1,az1,el1).asCartesian;

	rot1=[sph1.x,sph1.y,sph1.z];

	i1=Quaternion(0, rot1.[0], 0, 0);
	j1=Quaternion(0, 0, rot1.[1], 0);
	k1=Quaternion(0, 0, 0, rot1.[2]);

q1=(cos(angle.degrad)+(sin(angle.degrad)*(i1+j1+k1)));
v1=q1*v1*q1.conjugate;

raz1=Cartesian(v1.b.round(0.0001),v1.c.round(0.0001),v1.d.round(0.0001)).theta;
};

~az_y=(360*~time).collect{

	az2=~az.[pl2];el2=~el.[pl2];
	pl2=pl2+1;
sph2=Spherical(1,az2,el2).asCartesian;

	rot2=[sph2.x,sph2.y,sph2.z];

	i2=Quaternion(0, rot2.[0], 0, 0);
	j2=Quaternion(0, 0, rot2.[1], 0);
	k2=Quaternion(0, 0, 0, rot2.[2]);

q2=(cos(angle.degrad)+(sin(angle.degrad)*(i2+j2+k2)));
v2=q2*v2*q2.conjugate;

raz2=Cartesian(v2.b.round(0.0001),v2.c.round(0.0001),v2.d.round(0.0001)).theta;
};

~az_z=(360*~time).collect{

	az3=~az.[pl3];el3=~el.[pl3];
	pl3=pl3+1;
sph3=Spherical(1,az3,el3).asCartesian;

	rot3=[sph3.x,sph3.y,sph3.z];

	i3=Quaternion(0, rot3.[0], 0, 0);
	j3=Quaternion(0, 0, rot3.[1], 0);
	k3=Quaternion(0, 0, 0, rot3.[2]);

q3=(cos(angle.degrad)+(sin(angle.degrad)*(i3+j3+k3)));
v3=q3*v3*q3.conjugate;

raz3=Cartesian(v3.b.round(0.0001),v3.c.round(0.0001),v3.d.round(0.0001)).theta;
};

)

///////////////////////el
(
var pl1=0,az1,el1,sph1,rot1,i1,j1,k1,q1,raz1,rel1;
var pl2=0,az2,el2,sph2,rot2,i2,j2,k2,q2,raz2,rel2;
var pl3=0,az3,el3,sph3,rot3,i3,j3,k3,q3,raz3,rel3;
var r=[0,0,1];
var v1=Quaternion(0,r.[0],r.[1],r.[2]),v2=Quaternion(0,r.[0],r.[1],r.[2]),v3=Quaternion(0,r.[0],r.[1],r.[2]);
var angle=(360-(360/1.6180339887499));

~el_x=(360*~time).collect{

	az1=~az.[pl1];el1=~el.[pl1];
	pl1=pl1+1;
sph1=Spherical(1,az1,el1).asCartesian;

	rot1=[sph1.x,sph1.y,sph1.z];

	i1=Quaternion(0, rot1.[0], 0, 0);
	j1=Quaternion(0, 0, rot1.[1], 0);
	k1=Quaternion(0, 0, 0, rot1.[2]);

q1=(cos(angle.degrad)+(sin(angle.degrad)*(i1+j1+k1)));
v1=q1*v1*q1.conjugate;

raz1=Cartesian(v1.b.round(0.0001),v1.c.round(0.0001),v1.d.round(0.0001)).phi;
};

~el_y=(360*~time).collect{

	az2=~az.[pl2];el2=~el.[pl2];
	pl2=pl2+1;
sph2=Spherical(1,az2,el2).asCartesian;

	rot2=[sph2.x,sph2.y,sph2.z];

	i2=Quaternion(0, rot2.[0], 0, 0);
	j2=Quaternion(0, 0, rot2.[1], 0);
	k2=Quaternion(0, 0, 0, rot2.[2]);

q2=(cos(angle.degrad)+(sin(angle.degrad)*(i2+j2+k2)));
v2=q2*v2*q2.conjugate;

raz2=Cartesian(v2.b.round(0.0001),v2.c.round(0.0001),v2.d.round(0.0001)).phi;
};

~el_z=(360*~time).collect{

	az3=~az.[pl3];el3=~el.[pl3];
	pl3=pl3+1;
sph3=Spherical(1,az3,el3).asCartesian;

	rot3=[sph3.x,sph3.y,sph3.z];

	i3=Quaternion(0, rot3.[0], 0, 0);
	j3=Quaternion(0, 0, rot3.[1], 0);
	k3=Quaternion(0, 0, 0, rot3.[2]);

q3=(cos(angle.degrad)+(sin(angle.degrad)*(i3+j3+k3)));
v3=q3*v3*q3.conjugate;

raz3=Cartesian(v3.b.round(0.0001),v3.c.round(0.0001),v3.d.round(0.0001)).phi;
};

)
/////////////////notes and durs

(
var dur=1,ph1,ph2,ph3,pl1=0,pl2=0,pl3=0,pl4=0,pl5=0,pl6=0,sph1,sph2,sph3,n1,n2,n3,mult=12;
var mag1,mag2,mag3;

~phase2 = (360*~time).collect{
	ph1=~magx.[pl1];
	pl1=pl1+1;
	ph1=(ph1/dur).round(1/32);
	};

~phase3 = (360*~time).collect{
	ph2=~magy.[pl2];
	pl2=pl2+1;
	ph2=(ph2/dur).round(1/32);
	};

~phase4 = (360*~time).collect{
	ph3=~magz.[pl3];
	pl3=pl3+1;
	ph3=(ph3/dur).round((1/32));
	};
)

)
/////////////////synth
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


(
SynthDef.new(\o1, {
	arg n=1,decay=2,az1,el1,az2,el2;
    var in1, chainx,b=0;
	var chainxx,pitch,env;
	var wrappedOut1 = { |busArray, signalArray|
	[busArray, signalArray].flop.do { |pair|
		Out.ar(pair[0], pair[1])}};

	var out = NamedControl.kr(\out, [0, 1, 2, 3]);  // multiple buses!

	pitch=2.pow(n/12);

	env=EnvGen.ar(Env.sine(decay,pitch.reciprocal),doneAction:2);

	in1 = PitchShift.ar(SoundIn.ar(0),pitchRatio:pitch,mul:env);

	chainx = FFT(LocalBuf(1024), in1);

   250.do{

az1=(az1+(360-(360/1.6180339887499))).wrap(180.neg,180);
el1=(el1+(360-(360/1.6180339887499))).wrap(90.neg,90);

~azim1=16.collect{az1=(az1+(360-(360/1.6180339887499))).wrap(180.neg,180)};
~elev1=16.collect{el1=(el1+(360-(360/1.6180339887499))).wrap(90.neg,90)};

   chainxx = chainx.pvcollect(1024, {|mag, phase, index| [mag, phase]; }, frombin: b, tobin: b, zeroothers: 1);
	b=b+1;
	wrappedOut1.value(out,VBAP.ar(4,IFFT(chainxx),~b.bufnum,EnvGen.ar(Env(~azim1,[1/2])),EnvGen.ar(Env(~elev1,[1/2])))*env);
	}
}).add;
);


Scale.directory

//////////pattern for mobius strib of sequential or parallel play of directions
(
b=Pdef(\2, Pbind(\instrument, \o1,
	\dur,Pseq(~phase2.abs,1),
\n1,PdegreeToKey(Pseq(~n2,inf),Scale.mixolydian),
		\out,Pn(Pshuf([0, 1, 2, 3], 1), inf).clump(4).collect([_]),
	\az1,Pseq(~az1,inf),
	\el1,Pseq(~el1,inf),
	\az2,Pseq(~az1.reverse,inf),
	\el2,Pseq(~el1.reverse,inf),
		\buffer1,Pseq([0,1,2,3],inf),
	\buffer2,Pseq([0,1,2,3],inf),
	\decay,Pbrown(2,8,1,inf);
));
c=Pdef(\3, Pbind(\instrument, \o2,
	\dur,Pseq(~phase3.abs,1),
\n1,PdegreeToKey(Pseq(~n3,inf),Scale.mixolydian),
		\out,Pn(Pshuf([0, 1, 2, 3], 1), inf).clump(4).collect([_]),
	\az1,Pseq(~az2,inf),
	\el1,Pseq(~el2,inf),
	\az2,Pseq(~az2.reverse,inf),
	\el2,Pseq(~el2.reverse,inf),
		\buffer1,Pseq([0,1,2,3],inf),
	\buffer2,Pseq([0,1,2,3],inf),
	\decay,Pbrown(2,8,1,inf);
));
d=Pdef(\4, Pbind(\instrument, \o3,
	\dur,Pseq(~phase4.abs,1),
\n1,PdegreeToKey(Pseq(~n4,inf),Scale.mixolydian),
	\out,Pn(Pshuf([0, 1, 2, 3], 1), inf).clump(4).collect([_]),
	\az1,Pseq(~az3,inf),
	\el1,Pseq(~el3,inf),
	\az2,Pseq(~az3.reverse,inf),
	\el2,Pseq(~el3.reverse,inf),
	\decay,Pbrown(2,8,1,inf);
));
z=Pdef(\5, Pbind(\instrument, \o4,
	\dur,Pseq(~phase4.abs,1),
\n1,PdegreeToKey(Pseq(~n4,inf),Scale.mixolydian),
	\out,Pn(Pshuf([0, 1, 2, 3], 1), inf).clump(4).collect([_]),
	\az1,Pseq(~az3,inf),
	\el1,Pseq(~el3,inf),
	\az2,Pseq(~az3.reverse,inf),
	\el2,Pseq(~el3.reverse,inf),
	\decay,Pbrown(2,8,1,inf);
));
)

(
e=Pdef(\22, Pbind(\instrument, \o1,
	\dur,Pseq(~phase2.abs.reverse,1),
\n1,PdegreeToKey(Pseq(~n2.reverse,inf),Scale.mixolydian),
		\out,Pn(Pshuf([0, 1, 2, 3], 1), inf).clump(4).collect([_]),
	\az1,Pseq(~az1.reverse,inf),
	\el1,Pseq(~el2.reverse,inf),
	\az2,Pseq(~az1,inf),
	\el2,Pseq(~el2,inf),
	\decay,Pbrown(2,8,1,inf);
));
f=Pdef(\33, Pbind(\instrument, \o2,
	\dur,Pseq(~phase3.abs.reverse,1),
\n1,PdegreeToKey(Pseq(~n3.reverse,inf),Scale.mixolydian),
		\out,Pn(Pshuf([0, 1, 2, 3], 1), inf).clump(4).collect([_]),
	\az1,Pseq(~az2.reverse,inf),
	\el1,Pseq(~el2.reverse,inf),
	\az2,Pseq(~az2,inf),
	\el2,Pseq(~el2,inf),
	\decay,Pbrown(2,8,1,inf);
));
g=Pdef(\44, Pbind(\instrument, \o3,
	\dur,Pseq(~phase4.abs.reverse,1),
\n1,PdegreeToKey(Pseq(~n4.reverse,inf),Scale.mixolydian),
	\out,Pn(Pshuf([0, 1, 2, 3], 1), inf).clump(4).collect([_]),
\az1,Pseq(~az3.reverse,inf),
	\el1,Pseq(~el3.reverse,inf),
	\az2,Pseq(~az3,inf),
	\el2,Pseq(~el3,inf),
	\decay,Pbrown(2,8,1,inf);
));
k=Pdef(\55, Pbind(\instrument, \o4,
	\dur,Pseq(~phase4.abs.reverse,1),
\n1,PdegreeToKey(Pseq(~n4.reverse,inf),Scale.mixolydian),
	\out,Pn(Pshuf([0, 1, 2, 3], 1), inf).clump(4).collect([_]),
\az1,Pseq(~az3.reverse,inf),
	\el1,Pseq(~el3.reverse,inf),
	\az2,Pseq(~az3,inf),
	\el2,Pseq(~el3,inf),
	\decay,Pbrown(2,8,1,inf);
));
)

(
Tdef.new(\h,{loop({

	b.play;
c.play;
d.play;
	(1).wait;
		bb.play;
cc.play;
dd.play;


	}
)})
)


Tdef(\h).stop;
Tdef(\h).play;
Tdef(\h).clear;

////////////////pattern for web of directions

(

~phase22=~phase2.reverse.mirror;
~n22=~n2.reverse.mirror;
~phase33=~phase3.reverse.mirror;
~n33=~n3.reverse.mirror;
~phase44=~phase4.reverse.mirror;
~n44=~n4.reverse.mirror;

~phase2=~phase2.mirror;
~n2=~n2.mirror;
~phase3=~phase3.mirror;
~n3=~n3.mirror;
~phase4=~phase4.mirror;
~n4=~n4.mirror;

)

(
b=Pdef(\2, Pbind(\instrument, \o1,
	\dur,Ppatlace([Pseq(~phase2.abs,1),Pseq(~phase22.abs,1)],inf),
	\n1,PdegreeToKey(Ppatlace([Pseq(~n2,inf),Pseq(~n22,inf)],inf),Scale.mixolydian),
	\az1,Ppatlace([Pseq(~az1.reverse.mirror,inf),Pseq(~az1.mirror,inf)],inf),
	\el1,Ppatlace([Pseq(~el1.reverse.mirror,inf),Pseq(~el1.mirror,inf)],inf),
	\az2,Ppatlace([Pseq(~az1.mirror,inf),Pseq(~az1.reverse.mirror,inf)],inf),
	\el2,Ppatlace([Pseq(~el1.mirror,inf),Pseq(~el1.reverse.mirror,inf)],inf),
		\out,Pn(Pshuf([0, 1, 2, 3], 1), inf).clump(4).collect([_]),
	\decay,Pbrown(2,8,1,inf);
));
c=Pdef(\3, Pbind(\instrument, \o2,
	\dur,Ppatlace([Pseq(~phase3.abs,1),Pseq(~phase33.abs,1)],inf),
	\n1,PdegreeToKey(Ppatlace([Pseq(~n3,inf),Pseq(~n33,inf)],inf),Scale.mixolydian),
	\az1,Ppatlace([Pseq(~az2.reverse.mirror,inf),Pseq(~az2.mirror,inf)],inf),
	\el1,Ppatlace([Pseq(~el2.reverse.mirror,inf),Pseq(~el2.mirror,inf)],inf),
	\az2,Ppatlace([Pseq(~az2.mirror,inf),Pseq(~az2.reverse.mirror,inf)],inf),
	\el2,Ppatlace([Pseq(~el2.mirror,inf),Pseq(~el2.reverse.mirror,inf)],inf),
		\out,Pn(Pshuf([0, 1, 2, 3], 1), inf).clump(4).collect([_]),
	\decay,Pbrown(2,8,1,inf);
));
d=Pdef(\4, Pbind(\instrument, \o3,
	\dur,Ppatlace([Pseq(~phase4.abs,1),Pseq(~phase44.abs,1)],inf),
	\n1,PdegreeToKey(Ppatlace([Pseq(~n4,inf),Pseq(~n44,inf)],inf),Scale.mixolydian),
	\az1,Ppatlace([Pseq(~az3.reverse.mirror,inf),Pseq(~az3.mirror,inf)],inf),
	\el1,Ppatlace([Pseq(~el3.reverse.mirror,inf),Pseq(~el3.mirror,inf)],inf),
	\az2,Ppatlace([Pseq(~az3.mirror,inf),Pseq(~az3.reverse.mirror,inf)],inf),
	\el2,Ppatlace([Pseq(~el3.mirror,inf),Pseq(~el3.reverse.mirror,inf)],inf),
	\out,Pn(Pshuf([0, 1, 2, 3], 1), inf).clump(4).collect([_]),
	\decay,Pbrown(2,8,1,inf);
));
z=Pdef(\5, Pbind(\instrument, \o4,
	\dur,Ppatlace([Pseq(~phase4.abs,1),Pseq(~phase44.abs,1)],inf),
	\n1,PdegreeToKey(Ppatlace([Pseq(~n4,inf),Pseq(~n44,inf)],inf),Scale.mixolydian),
	\az1,Ppatlace([Pseq(~az3.reverse.mirror,inf),Pseq(~az3.mirror,inf)],inf),
	\el1,Ppatlace([Pseq(~el3.reverse.mirror,inf),Pseq(~el3.mirror,inf)],inf),
	\az2,Ppatlace([Pseq(~az3.mirror,inf),Pseq(~az3.reverse.mirror,inf)],inf),
	\el2,Ppatlace([Pseq(~el3.mirror,inf),Pseq(~el3.reverse.mirror,inf)],inf),
	\out,Pn(Pshuf([0, 1, 2, 3], 1), inf).clump(4).collect([_]),
	\decay,Pbrown(2,8,1,inf);
));
)


(
b.play;
//s.record(numChannels:4)
//)
//(
c.play;
//s.record(numChannels:4)
//)
//(
d.play;
s.record(numChannels:4)
)


/////////////////////////////////in one pattern
(

~phase22=~phase2.reverse.mirror;
~n22=~n2.reverse.mirror;
~phase33=~phase3.reverse.mirror;
~n33=~n3.reverse.mirror;
~phase44=~phase4.reverse.mirror;
~n44=~n4.reverse.mirror;

~phase2=~phase2.mirror;
~n2=~n2.mirror;
~phase3=~phase3.mirror;
~n3=~n3.mirror;
~phase4=~phase4.mirror;
~n4=~n4.mirror;

)
(
b=Pdef(\2, Pbind(\instrument, \o1,
	\dur,Pseq(~phase2.abs,1),
\n1,PdegreeToKey(Pseq(~n2,inf),Scale.mixolydian),
		\out,Pn(Pshuf([0, 1, 2, 3], 1), inf).clump(4).collect([_]),
	\az1,Pseq(~az1.reverse.mirror,inf),
	\el1,Pseq(~el1.reverse.mirror,inf),
	\az2,Pseq(~az2.mirror,inf),
	\el2,Pseq(~el2.mirror,inf),
	\buffer1,Pseq([0,1,2,3],inf),
	\buffer2,Pseq([0,1,2,3],inf),
	\decay,Pbrown(2,8,1,inf);
));
c=Pdef(\3, Pbind(\instrument, \o2,
	\dur,Pseq(~phase3.abs,1),
\n1,PdegreeToKey(Pseq(~n3,inf),Scale.mixolydian),
		\out,Pn(Pshuf([0, 1, 2, 3], 1), inf).clump(4).collect([_]),
	\az1,Pseq(~az1.reverse.mirror,inf),
	\el1,Pseq(~el1.reverse.mirror,inf),
	\az2,Pseq(~az2.mirror,inf),
	\el2,Pseq(~el2.mirror,inf),
	\decay,Pbrown(2,8,1,inf);
));
d=Pdef(\4, Pbind(\instrument, \o3,

	\dur,Pseq(~phase4.abs,1),
\n1,PdegreeToKey(Pseq(~n4,inf),Scale.mixolydian),
	\out,Pn(Pshuf([0, 1, 2, 3], 1), inf).clump(4).collect([_]),
	\az1,Pseq(~az1.reverse.mirror,inf),
	\el1,Pseq(~el1.reverse.mirror,inf),
	\az2,Pseq(~az2.mirror,inf),
	\el2,Pseq(~el2.mirror,inf),
	\decay,Pbrown(2,8,1,inf);
));
z=Pdef(\5, Pbind(\instrument, \o4,

	\dur,Pseq(~phase4.abs,1),
\n1,PdegreeToKey(Pseq(~n4,inf),Scale.mixolydian),
	\out,Pn(Pshuf([0, 1, 2, 3], 1), inf).clump(4).collect([_]),
	\az1,Pseq(~az1.reverse.mirror,inf),
	\el1,Pseq(~el1.reverse.mirror,inf),
	\az2,Pseq(~az2.mirror,inf),
	\el2,Pseq(~el2.mirror,inf),
	\decay,Pbrown(2,8,1,inf);
));
)
(
e=Pdef(\22, Pbind(\instrument, \o1,

	\dur,Pseq(~phase22.abs,1),
\n1,PdegreeToKey(Pseq(~n22,inf),Scale.mixolydian),
		\out,Pn(Pshuf([0, 1, 2, 3], 1), inf).clump(4).collect([_]),
	\az1,Pseq(~az1.mirror,inf),
	\el1,Pseq(~el1.mirror,inf),
	\az2,Pseq(~az2.reverse.mirror,inf),
	\el2,Pseq(~el2.reverse..mirror,inf),
	\decay,Pbrown(2,8,1,inf);
));
f=Pdef(\33, Pbind(\instrument, \o2,
	\dur,Pseq(~phase33.abs,1),
\n1,PdegreeToKey(Pseq(~n33,inf),Scale.mixolydian),
		\out,Pn(Pshuf([0, 1, 2, 3], 1), inf).clump(4).collect([_]),
	\az1,Pseq(~az1.mirror,inf),
	\el1,Pseq(~el1.mirror,inf),
	\az2,Pseq(~az2.reverse.mirror,inf),
	\el2,Pseq(~el2.reverse.mirror,inf),
	\decay,Pbrown(2,8,1,inf);
));
g=Pdef(\44, Pbind(\instrument, \o3,
	\dur,Pseq(~phase44.abs,1),
\n1,PdegreeToKey(Pseq(~n44,inf),Scale.mixolydian),
	\out,Pn(Pshuf([0, 1, 2, 3], 1), inf).clump(4).collect([_]),
		\az1,Pseq(~az1.mirror,inf),
	\el1,Pseq(~el1.mirror,inf),
	\az2,Pseq(~az2.reverse.mirror,inf),
	\el2,Pseq(~el2.reverse.mirror,inf),
	\decay,Pbrown(2,8,1,inf);
));
k=Pdef(\55, Pbind(\instrument, \o4,
	\dur,Pseq(~phase44.abs,1),
\n1,PdegreeToKey(Pseq(~n44,inf),Scale.mixolydian),
	\out,Pn(Pshuf([0, 1, 2, 3], 1), inf).clump(4).collect([_]),
		\az1,Pseq(~az1.mirror,inf),
	\el1,Pseq(~el1.mirror,inf),
	\az2,Pseq(~az2.reverse.mirror,inf),
	\el2,Pseq(~el2.reverse.mirror,inf),
	\decay,Pbrown(2,8,1,inf);
));
)
(
b.play;
//s.record(numChannels:4)
//)
//(
c.play;
//s.record(numChannels:4)
//)
//(
d.play;
e.play;
//s.record(numChannels:4)
//)
//(
f.play;
//s.record(numChannels:4)
//)
//(
g.play;
s.record(numChannels:4)
)

(
Tdef.new(\h,{loop({

	b.play;
c.play;
d.play;
	(1).wait;
		bb.play;
cc.play;
dd.play;


	}
)})
)


Tdef(\h).stop;
Tdef(\h).play;
Tdef(\h).clear;
