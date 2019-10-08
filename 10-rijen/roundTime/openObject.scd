
p.push();
thisProcess.openUDPPort(57120);
OpenObject.start;
OpenObject.openInterpreter;


(

SynthDef(\a,{|freq=50,sus=0.75|
	var env = {EnvGen.ar(Env.new([0,1,0],[0.02,~sus.kr]),doneAction:2)};
	var sig = SinOsc.ar(freq!2,env**~slope.kr*8pi);
	sig = sig * env;
    sig = Splay.ar(sig,0.9,1);
	Out.ar(0,sig);

}).add;

)
