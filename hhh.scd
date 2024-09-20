(
var data;
var az=0,el=0,mag=0;
var i = Quaternion(0, (1/3).sqrt, 0, 0),j = Quaternion(0, 0, (1/3).sqrt,0),k = Quaternion(0, 0, 0, (1/3).sqrt);
var q,v,vr,angle=0,r,d,m=1,sph,pl=0,harm;

r=[0,1,0].normalizeSum;
angle=(360-(360/1.6180339887499));
i=Quaternion(0, r.[0], 0, 0);
j=Quaternion(0, 0, r.[1], 0);
k=Quaternion(0, 0, 0, r.[2]);

data = (360*32).collect{

	az=~az.[pl];
	el=~el.[pl];
	mag=(Complex(~magL.[pl]/(2.sqrt),~magR.[pl]/(2.sqrt)).rho/(2.sqrt));
	pl=pl+1;

	sph=Spherical(mag,az,el);

	v=Quaternion(0,sph.x,sph.y,sph.z);

	q=(cos(angle.degrad)+(sin(angle.degrad)*(i+j+k)));
v=q*v*q.conjugate;

	harm=Cartesian(v.b,v.c,v.d).asArray


};

w = Window.new("3D Scatterplot", Rect(40,40, 1000, 800)).front;
a = ScatterView3d(w, Rect(0,0, 800,800), data, [-1000, 1000].asSpec,[-1000, 1000].asSpec,[-1000, 1000].asSpec);
a.drawMethod = \fillRect;
a.symbolSize = 1;
a.symbolColor = Color.white;
a.background = Color.black;

// Y Slider
Slider(w, Rect(820, 10, 10, 450)).action_{|me|
    a.rotY = me.value * 2pi;
    w.refresh;
};
// X Slider
Slider(w, Rect(870, 10, 10, 450)).action_{|me|
    a.rotX = me.value * 2pi;
    w.refresh;
};
// Z Slider
Slider(w, Rect(920, 10, 10, 450)).action_{|me|
    a.rotZ = me.value * 2pi;
    w.refresh;
};
)