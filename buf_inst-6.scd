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


Buffer.freeAll
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


////////////////buffers
(
~c1 = Buffer.readChannel(s,,channels:0 );
~c2 = Buffer.readChannel(s,,channels:1 );
~c3 = Buffer.readChannel(s,,channels:0 );
~c4 = Buffer.readChannel(s,,channels:1 );
~c5 = Buffer.readChannel(s,,channels:0 );
~c6 = Buffer.readChannel(s,,channels:1 );
~c7 = Buffer.readChannel(s,,channels:0 );
~c8 = Buffer.readChannel(s,,channels:1 );
~c9 = Buffer.readChannel(s,,channels:0 );
~c10 = Buffer.readChannel(s,,channels:1 );
~c11 = Buffer.readChannel(s,,channels:0 );
~c12 = Buffer.readChannel(s,,channels:1 );
~c13 = Buffer.readChannel(s,,channels:0 );
~c14 = Buffer.readChannel(s,,channels:1 );
~c15 = Buffer.readChannel(s,,channels:0 );
~c16 = Buffer.readChannel(s,,channels:1 );
)

//////////////arrays

(
~time=1;
(
var  sph1,sph2,m_x=2,m_y=2,m_z=2,az1=0,el1=0,az2=0,el2=0,mag_x,mag_y,mag_z;
var azx=0,elx=0,azy=0,ely=0,azz=0,elz=0,sphx,sphy,sphz,rad=1;

~az = (360*~time).collect{

		az1=(az1+(1)).wrap(180.neg,180);

	el1=(el1+(360-(360/1.6180339887499))).wrap(90.neg,90);

	sph1=Spherical(1,az1.degrad,el1.degrad).theta.round(0.000000001);

	};

~el = (360*~time).collect{

		az2=(az2+(1)).wrap(180.neg,180);

	el2=(el2+(360-(360/1.6180339887499))).wrap(90.neg,90);

	sph2=Spherical(1,az2.degrad,el2.degrad).phi.round(0.000000001);

	};

~magx = (360*~time).collect{

	azx=(azx+(1)).wrap(180.neg,180);

	elx=(elx+(360-(360/1.6180339887499))).wrap(90.neg,90);

	sphx=Spherical(rad,azx.degrad,elx.degrad);

	mag_x=(Complex(cos((sphx.theta.round(0.000000001)*m_x).wrap(pi.neg,pi)),cos((sphx.theta.round(0.000000001)*m_x).wrap(pi.neg,pi))).rho*
	Complex(cos((sphx.phi.round(0.000000001)).wrap((pi/2).neg,(pi/2))),cos((sphx.phi.round(0.000000001)).wrap((pi/2).neg,(pi/2)))).rho)*sphx.rho;

//mag_x=(Complex(cos((sphx.theta.round(0.000000001)*m_x).wrap(pi.neg,pi)),cos((sphx.theta.round(0.000000001)*m_x).wrap(pi.neg,pi))).rho*
//Complex(sin((sphx.phi.round(0.000000001)*(m_x-1)).wrap((pi/2).neg,(pi/2))),sin((sphx.phi.round(0.000000001)*(m_x-1)).wrap((pi/2).neg,(pi/2)))).rho*
//Complex(cos((sphx.phi.round(0.000000001)).wrap((pi/2).neg,(pi/2))),cos((sphx.phi.round(0.000000001)).wrap((pi/2).neg,(pi/2)))).rho)*sphx.rho;

	mag_x=mag_x/(2.sqrt);
	};

~magy = (360*~time).collect{

	azy=(azy+(1)).wrap(180.neg,180);

	ely=(ely+(360-(360/1.6180339887499))).wrap(90.neg,90);

	sphy=Spherical(rad,azy.degrad,ely.degrad);

	mag_y=(Complex(sin((sphy.theta.round(0.000000001)*m_y).wrap(pi.neg,pi)),sin((sphy.theta.round(0.000000001)*m_y).wrap(pi.neg,pi))).rho*
		Complex(cos((sphy.phi.round(0.000000001)).wrap((pi/2).neg,(pi/2))),cos((sphy.phi.round(0.000000001)).wrap((pi/2).neg,(pi/2)))).rho)*sphy.rho;

//	mag_y=(Complex(sin((sphy.theta.round(0.000000001)*m_y).wrap(pi.neg,pi)),sin((sphy.theta.round(0.000000001)*m_y).wrap(pi.neg,pi))).rho*
//Complex(sin((sphy.phi.round(0.000000001)*(m_y-1)).wrap((pi/2).neg,(pi/2))),sin((sphy.phi.round(0.000000001)*(m_y-1)).wrap((pi/2).neg,(pi/2)))).rho*
//Complex(cos((sphy.phi.round(0.000000001)).wrap((pi/2).neg,(pi/2))),cos((sphy.phi.round(0.000000001)).wrap((pi/2).neg,(pi/2)))).rho)*sphy.rho;

mag_y=mag_y/(2.sqrt);
	};

~magz = (360*~time).collect{

	azz=(azz+(1)).wrap(180.neg,180);

	elz=(elz+(360-(360/1.6180339887499))).wrap(90.neg,90);

	sphz=Spherical(rad,azz.degrad,elz.degrad);

if(
m_z.even,
mag_z=Complex(cos((sphz.phi.round(0.000000001)*m_z).wrap((pi/2).neg,(pi/2))),cos((sphz.phi.round(0.000000001)*m_z).wrap((pi/2).neg,(pi/2)))).rho*sphz.rho,
mag_z=Complex(sin((sphz.phi.round(0.000000001)*m_z).wrap((pi/2).neg,(pi/2))),sin((sphz.phi.round(0.000000001)*m_z).wrap((pi/2).neg,(pi/2)))).rho*sphz.rho
	);
	mag_z=mag_z/(2.sqrt);
	};

)

)

////////////synth
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
(
SynthDef.new(\o1, {
    var in1,in2, chainx,chainy,b=0,az1=0,az2=0,el1=0,el2=0;
	var chainxx,chainyy,pl=0;

    in1 = PlayBuf.ar(1, ~c1.bufnum, BufRateScale.kr(~c1), loop: 0, doneAction:2);
	 in2 = PlayBuf.ar(1, ~c2.bufnum, BufRateScale.kr(~c2), loop: 0, doneAction:2);

	chainx = FFT(LocalBuf(1024), in1);
	chainy = FFT(LocalBuf(1024), in2);

   360.do{

		az1=~az.[pl];
		el1=~el.[pl];
		az2=~az.reverse.[pl];
		el2=~el.reverse.[pl];

   chainxx = chainx.pvcollect(1024, {|mag, phase, index| [mag, phase]; }, frombin: b, tobin: b, zeroothers: 1);
   chainyy = chainy.pvcollect(1024, {|mag, phase, index| [mag, phase]; }, frombin: b, tobin: b, zeroothers: 1);

	b=b+1;

		Out.ar(0,VBAP.ar(4,IFFT(chainxx),~b.bufnum,
		Osc.ar(~t,1/2,phase:az1.linlin(pi.neg,pi,2pi.neg,2pi),mul:180),
			Osc.ar(~t,1/2,phase:el1.linlin((pi/2).neg,(pi/2),2pi.neg,2pi),mul:90))
		*Cartesian(~magx.[pl],~magy.[pl],~magz.[pl]).rho);

		Out.ar(0,VBAP.ar(4,IFFT(chainyy),~b.bufnum,
		Osc.ar(~t,1/2,phase:az2.linlin(pi.neg,pi,2pi.neg,2pi),mul:180),
			Osc.ar(~t,1/2,phase:el2.linlin((pi/2).neg,(pi/2),2pi.neg,2pi),mul:90))
		*Cartesian(~magx.reverse.[pl],~magy.reverse.[pl],~magz.reverse.[pl]).rho);

		pl=pl+1;
	}
}).add;
);
(
SynthDef.new(\o2, {
    var in1,in2, chainx,chainy,b=0,az1,az2,el1,el2;
	var chainxx,chainyy,pl=0;

    in1 = PlayBuf.ar(1, ~c3.bufnum, BufRateScale.kr(~c3), loop: 0, doneAction:2);
	 in2 = PlayBuf.ar(1, ~c4.bufnum, BufRateScale.kr(~c4), loop: 0, doneAction:2);

	chainx = FFT(LocalBuf(1024), in1);
	chainy = FFT(LocalBuf(1024), in2);

   360.do{

		az1=~az.[pl];
		el1=~el.[pl];
		az2=~az.reverse.[pl];
		el2=~el.reverse.[pl];

   chainxx = chainx.pvcollect(1024, {|mag, phase, index| [mag, phase]; }, frombin: b, tobin: b, zeroothers: 1);
   chainyy = chainy.pvcollect(1024, {|mag, phase, index| [mag, phase]; }, frombin: b, tobin: b, zeroothers: 1);

	b=b+1;

		Out.ar(0,VBAP.ar(4,IFFT(chainxx),~b.bufnum,
		Osc.ar(~t,1/2,phase:az1.linlin(pi.neg,pi,2pi.neg,2pi),mul:180),
			Osc.ar(~t,1/2,phase:el1.linlin((pi/2).neg,(pi/2),2pi.neg,2pi),mul:90))
		*Cartesian(~magx.[pl],~magy.[pl],~magz.[pl]).rho);

		Out.ar(0,VBAP.ar(4,IFFT(chainyy),~b.bufnum,
		Osc.ar(~t,1/2,phase:az2.linlin(pi.neg,pi,2pi.neg,2pi),mul:180),
			Osc.ar(~t,1/2,phase:el2.linlin((pi/2).neg,(pi/2),2pi.neg,2pi),mul:90))
		*Cartesian(~magx.reverse.[pl],~magy.reverse.[pl],~magz.reverse.[pl]).rho);

		pl=pl+1;
	}
}).add;
);
(
SynthDef.new(\o3, {
    var in1,in2, chainx,chainy,b=0,az1,az2,el1,el2;
	var chainxx,chainyy,pl=0;

    in1 = PlayBuf.ar(1, ~c5.bufnum, BufRateScale.kr(~c5), loop: 0, doneAction:2);
	 in2 = PlayBuf.ar(1, ~c6.bufnum, BufRateScale.kr(~c6), loop: 0, doneAction:2);

	chainx = FFT(LocalBuf(1024), in1);
	chainy = FFT(LocalBuf(1024), in2);

   360.do{

		az1=~az.[pl];
		el1=~el.[pl];
		az2=~az.reverse.[pl];
		el2=~el.reverse.[pl];

   chainxx = chainx.pvcollect(1024, {|mag, phase, index| [mag, phase]; }, frombin: b, tobin: b, zeroothers: 1);
   chainyy = chainy.pvcollect(1024, {|mag, phase, index| [mag, phase]; }, frombin: b, tobin: b, zeroothers: 1);

	b=b+1;

		Out.ar(0,VBAP.ar(4,IFFT(chainxx),~b.bufnum,
		Osc.ar(~t,1/2,phase:az1.linlin(pi.neg,pi,2pi.neg,2pi),mul:180),
			Osc.ar(~t,1/2,phase:el1.linlin((pi/2).neg,(pi/2),2pi.neg,2pi),mul:90))
		*Cartesian(~magx.[pl],~magy.[pl],~magz.[pl]).rho);

		Out.ar(0,VBAP.ar(4,IFFT(chainyy),~b.bufnum,
		Osc.ar(~t,1/2,phase:az2.linlin(pi.neg,pi,2pi.neg,2pi),mul:180),
			Osc.ar(~t,1/2,phase:el2.linlin((pi/2).neg,(pi/2),2pi.neg,2pi),mul:90))
		*Cartesian(~magx.reverse.[pl],~magy.reverse.[pl],~magz.reverse.[pl]).rho);

		pl=pl+1;
	}
}).add;
);
(
SynthDef.new(\o4, {
    var in1,in2, chainx,chainy,b=0,az1,az2,el1,el2;
	var chainxx,chainyy,pl=0;

    in1 = PlayBuf.ar(1, ~c7.bufnum, BufRateScale.kr(~c7), loop: 0, doneAction:2);
	 in2 = PlayBuf.ar(1, ~c8.bufnum, BufRateScale.kr(~c8), loop: 0, doneAction:2);

	chainx = FFT(LocalBuf(1024), in1);
	chainy = FFT(LocalBuf(1024), in2);

   360.do{

		az1=~az.[pl];
		el1=~el.[pl];
		az2=~az.reverse.[pl];
		el2=~el.reverse.[pl];

   chainxx = chainx.pvcollect(1024, {|mag, phase, index| [mag, phase]; }, frombin: b, tobin: b, zeroothers: 1);
   chainyy = chainy.pvcollect(1024, {|mag, phase, index| [mag, phase]; }, frombin: b, tobin: b, zeroothers: 1);

	b=b+1;

		Out.ar(0,VBAP.ar(4,IFFT(chainxx),~b.bufnum,
		Osc.ar(~t,1/2,phase:az1.linlin(pi.neg,pi,2pi.neg,2pi),mul:180),
			Osc.ar(~t,1/2,phase:el1.linlin((pi/2).neg,(pi/2),2pi.neg,2pi),mul:90))
		*Cartesian(~magx.[pl],~magy.[pl],~magz.[pl]).rho);

		Out.ar(0,VBAP.ar(4,IFFT(chainyy),~b.bufnum,
		Osc.ar(~t,1/2,phase:az2.linlin(pi.neg,pi,2pi.neg,2pi),mul:180),
			Osc.ar(~t,1/2,phase:el2.linlin((pi/2).neg,(pi/2),2pi.neg,2pi),mul:90))
		*Cartesian(~magx.reverse.[pl],~magy.reverse.[pl],~magz.reverse.[pl]).rho);

		pl=pl+1;
	}
}).add;
);
(
SynthDef.new(\o5, {
    var in1,in2, chainx,chainy,b=0,az1,az2,el1,el2;
	var chainxx,chainyy,pl=0;

    in1 = PlayBuf.ar(1, ~c9.bufnum, BufRateScale.kr(~c9), loop: 0, doneAction:2);
	 in2 = PlayBuf.ar(1, ~c10.bufnum, BufRateScale.kr(~c10), loop: 0, doneAction:2);

	chainx = FFT(LocalBuf(1024), in1);
	chainy = FFT(LocalBuf(1024), in2);

   360.do{

		az1=~az.[pl];
		el1=~el.[pl];
		az2=~az.reverse.[pl];
		el2=~el.reverse.[pl];

   chainxx = chainx.pvcollect(1024, {|mag, phase, index| [mag, phase]; }, frombin: b, tobin: b, zeroothers: 1);
   chainyy = chainy.pvcollect(1024, {|mag, phase, index| [mag, phase]; }, frombin: b, tobin: b, zeroothers: 1);

	b=b+1;

		Out.ar(0,VBAP.ar(4,IFFT(chainxx),~b.bufnum,
		Osc.ar(~t,1/2,phase:az1.linlin(pi.neg,pi,2pi.neg,2pi),mul:180),
			Osc.ar(~t,1/2,phase:el1.linlin((pi/2).neg,(pi/2),2pi.neg,2pi),mul:90))
		*Cartesian(~magx.[pl],~magy.[pl],~magz.[pl]).rho);

		Out.ar(0,VBAP.ar(4,IFFT(chainyy),~b.bufnum,
		Osc.ar(~t,1/2,phase:az2.linlin(pi.neg,pi,2pi.neg,2pi),mul:180),
			Osc.ar(~t,1/2,phase:el2.linlin((pi/2).neg,(pi/2),2pi.neg,2pi),mul:90))
		*Cartesian(~magx.reverse.[pl],~magy.reverse.[pl],~magz.reverse.[pl]).rho);

		pl=pl+1;
	}
}).add;
);
(
SynthDef.new(\o6, {
    var in1,in2, chainx,chainy,b=0,az1,az2,el1,el2;
	var chainxx,chainyy,pl=0;

    in1 = PlayBuf.ar(1, ~c11.bufnum, BufRateScale.kr(~c11), loop: 0, doneAction:2);
	 in2 = PlayBuf.ar(1, ~c12.bufnum, BufRateScale.kr(~c12), loop: 0, doneAction:2);

	chainx = FFT(LocalBuf(1024), in1);
	chainy = FFT(LocalBuf(1024), in2);

   360.do{

		az1=~az.[pl];
		el1=~el.[pl];
		az2=~az.reverse.[pl];
		el2=~el.reverse.[pl];

   chainxx = chainx.pvcollect(1024, {|mag, phase, index| [mag, phase]; }, frombin: b, tobin: b, zeroothers: 1);
   chainyy = chainy.pvcollect(1024, {|mag, phase, index| [mag, phase]; }, frombin: b, tobin: b, zeroothers: 1);

	b=b+1;

		Out.ar(0,VBAP.ar(4,IFFT(chainxx),~b.bufnum,
		Osc.ar(~t,1/2,phase:az1.linlin(pi.neg,pi,2pi.neg,2pi),mul:180),
			Osc.ar(~t,1/2,phase:el1.linlin((pi/2).neg,(pi/2),2pi.neg,2pi),mul:90))
		*Cartesian(~magx.[pl],~magy.[pl],~magz.[pl]).rho);

		Out.ar(0,VBAP.ar(4,IFFT(chainyy),~b.bufnum,
		Osc.ar(~t,1/2,phase:az2.linlin(pi.neg,pi,2pi.neg,2pi),mul:180),
			Osc.ar(~t,1/2,phase:el2.linlin((pi/2).neg,(pi/2),2pi.neg,2pi),mul:90))
		*Cartesian(~magx.reverse.[pl],~magy.reverse.[pl],~magz.reverse.[pl]).rho);

		pl=pl+1;
	}
}).add;
);
(
SynthDef.new(\o7, {
    var in1,in2, chainx,chainy,b=0,az1,az2,el1,el2;
	var chainxx,chainyy,pl=0;

    in1 = PlayBuf.ar(1, ~c13.bufnum, BufRateScale.kr(~c13), loop: 0, doneAction:2);
	 in2 = PlayBuf.ar(1, ~c14.bufnum, BufRateScale.kr(~c14), loop: 0, doneAction:2);

	chainx = FFT(LocalBuf(1024), in1);
	chainy = FFT(LocalBuf(1024), in2);

   360.do{

		az1=~az.[pl];
		el1=~el.[pl];
		az2=~az.reverse.[pl];
		el2=~el.reverse.[pl];

   chainxx = chainx.pvcollect(1024, {|mag, phase, index| [mag, phase]; }, frombin: b, tobin: b, zeroothers: 1);
   chainyy = chainy.pvcollect(1024, {|mag, phase, index| [mag, phase]; }, frombin: b, tobin: b, zeroothers: 1);

	b=b+1;

		Out.ar(0,VBAP.ar(4,IFFT(chainxx),~b.bufnum,
		Osc.ar(~t,1/2,phase:az1.linlin(pi.neg,pi,2pi.neg,2pi),mul:180),
			Osc.ar(~t,1/2,phase:el1.linlin((pi/2).neg,(pi/2),2pi.neg,2pi),mul:90))
		*Cartesian(~magx.[pl],~magy.[pl],~magz.[pl]).rho);

		Out.ar(0,VBAP.ar(4,IFFT(chainyy),~b.bufnum,
		Osc.ar(~t,1/2,phase:az2.linlin(pi.neg,pi,2pi.neg,2pi),mul:180),
			Osc.ar(~t,1/2,phase:el2.linlin((pi/2).neg,(pi/2),2pi.neg,2pi),mul:90))
		*Cartesian(~magx.reverse.[pl],~magy.reverse.[pl],~magz.reverse.[pl]).rho);

		pl=pl+1;
	}
}).add;
);
(
SynthDef.new(\o8, {
    var in1,in2, chainx,chainy,b=0,az1,az2,el1,el2;
	var chainxx,chainyy,pl=0,;

    in1 = PlayBuf.ar(1, ~c15.bufnum, BufRateScale.kr(~c15), loop: 0, doneAction:2);
	 in2 = PlayBuf.ar(1, ~c16.bufnum, BufRateScale.kr(~c16), loop: 0, doneAction:2);

	chainx = FFT(LocalBuf(1024), in1);
	chainy = FFT(LocalBuf(1024), in2);

   360.do{

		az1=~az.[pl];
		el1=~el.[pl];
		az2=~az.reverse.[pl];
		el2=~el.reverse.[pl];

   chainxx = chainx.pvcollect(1024, {|mag, phase, index| [mag, phase]; }, frombin: b, tobin: b, zeroothers: 1);
   chainyy = chainy.pvcollect(1024, {|mag, phase, index| [mag, phase]; }, frombin: b, tobin: b, zeroothers: 1);

	b=b+1;

		Out.ar(0,VBAP.ar(4,IFFT(chainxx),~b.bufnum,
		Osc.ar(~t,1/2,phase:az1.linlin(pi.neg,pi,2pi.neg,2pi),mul:180),
			Osc.ar(~t,1/2,phase:el1.linlin((pi/2).neg,(pi/2),2pi.neg,2pi),mul:90))
		*Cartesian(~magx.[pl],~magy.[pl],~magz.[pl]).rho);

		Out.ar(0,VBAP.ar(4,IFFT(chainyy),~b.bufnum,
		Osc.ar(~t,1/2,phase:az2.linlin(pi.neg,pi,2pi.neg,2pi),mul:180),
			Osc.ar(~t,1/2,phase:el2.linlin((pi/2).neg,(pi/2),2pi.neg,2pi),mul:90))
		*Cartesian(~magx.reverse.[pl],~magy.reverse.[pl],~magz.reverse.[pl]).rho);

		pl=pl+1;
	}
}).add;
);
)

(
Synth(\o1);
s.record(numChannels:4)
Synth(\o2);
s.record(numChannels:4)
Synth(\o3);
s.record(numChannels:4)
Synth(\o4);
s.record(numChannels:4)
Synth(\o5);
s.record(numChannels:4)
Synth(\o6);
s.record(numChannels:4)
Synth(\o7);
s.record(numChannels:4)
Synth(\o8);
s.record(numChannels:4)
)