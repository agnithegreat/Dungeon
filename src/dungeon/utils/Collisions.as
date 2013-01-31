package dungeon.utils {
    import nape.space.Space;
    import nape.phys.Body;
	import nape.callbacks.CbType;
    import nape.dynamics.Arbiter;

    public class Collisions {
		
        private var interesting:Object;
        private function pairId(i1:int, i2:int):int {
            return i1<i2 ? (i1<<16)|i2 : (i2<<16)|i1;
        }
        
        private var interacting:Object;
        
        public function Collisions() { interesting = {}; interacting = {}; }
      
        public function addPair(c1:CbType, c2:CbType, begin:Function, end:Function):Boolean {
            var id:int = pairId(c1.id,c2.id);
            if(interesting[id]!=null) return false;
            interesting[id] = {begin:begin, end:end, c1:c1, c2:c2, val:false, stamp:-1};
            return true;
        }
        
        public function remPair(c1:CbType,c2:CbType):Boolean {
            var id:int = pairId(c1.id,c2.id);
            var ret:Boolean = interesting[id]!=null;
            if(ret) interesting[id] = null;
            return ret;
        }
        
        public function handleCallbacks(space:Space):void {
            //handle begin
            var arbs:int = space.arbiters.length;
            for(var i:int = 0; i<arbs; i++) {
                var arb:Arbiter = space.arbiters.at(i);
                if(!arb.isCollisionArbiter()) continue;
                
                var id:int = pairId(arb.body1.cbType.id,arb.body2.cbType.id);
                var obj:Object = interesting[id];
                if(obj==null) continue;
                
                var id2:int = pairId(arb.body1.id,arb.body2.id);
                var tin:Object = interacting[id2];
                if(tin!=null) { tin.stamp = space.timeStamp; continue; }
                
                var b1:Body, b2:Body;
                if(obj.c1 == arb.body1.cbType) {
                    b1 = arb.body1; b2 = arb.body2;
                }else {
                    b1 = arb.body2; b2 = arb.body1;
                }
                
                if(obj.begin!=null)
                    obj.begin(b1,b2);
                
                interacting[id2] = {obj:obj, b1:b1, b2:b2, stamp:space.timeStamp};
            }
            
            //handle end
			for (var val:* in interacting) {
				tin = interacting[val];
                if(tin.stamp!=space.timeStamp) {
                    //ensure it's not due to sleeping
                    if(!((!tin.b1.isDynamic() || tin.b1.isSleeping)
                    && (!tin.b2.isDynamic() || tin.b2.isSleeping))) {
                        if (tin.obj.end != null) tin.obj.end(tin.b1, tin.b2);
						interacting[val] = null;
						delete interacting[val];
                    }
                }
            }
        }
    }
}
