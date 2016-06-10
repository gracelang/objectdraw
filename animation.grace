import "timer" as timer

// type of a block that takes no parameters and returns a boolean
type BoolBlock = Block0[[Boolean]]
type NumberBlock = Block0[[Number]]
type Procedure = Block0[[Done]]

// type of object that can simulate parallel animations
type Animator = {
   // Repeatedly execute block while condition is true
   while (condition: BoolBlock) pausing (pauseTime: Number) do (block: Procedure) -> Done

   // Repeatedly execute block while condition is true, pausing pauseTime between iterations
   // when condition fails, execute endBlock.
   while (condition: BoolBlock) pausing (pauseTime: Number) do (block: Procedure) 
                         finally (endBlock: Procedure) -> Done

   // Repeatedly execute block while condition is true
   // pausing variable amount of time (obtained by evaluating timeBlock) between iterations
   // when condition fails, execute endBlock.
   while (condition: BoolBlock) pauseVarying (pauseTime: Number) do (block: Procedure) -> Done

   // Repeatedly execute block while condition is true
   for[[T]] (range': Iterable[[T]]) pausing (pauseTime: Number) do (block: Block1[[T,Done]]) -> Done 
 
   // Repeatedly execute block while condition is true
   // when condition fails, execute endBlock.
   for[[T]] (range':Iterable[[T]]) pausing (pauseTime: Number) do (block:Block1[[T,Done]])
                                      finally (endBlock: Procedure) -> Done

}

// Repeatedly execute block while condition is true
method while(condition:BoolBlock) pausing (pauseTime:Number) do (block:Procedure) -> Done {
  def id: Number = timer.every (pauseTime) do {
     if (condition.apply) then {
        block.apply
     } else {
        timer.stop (id)
     }
  }
}

// Repeatedly execute block while condition is true, pausing by pauseTime
// between iterations. When condition fails, execute endBlock.
method while (condition: BoolBlock) pausing (pauseTime: Number) do (block:Procedure) 
                  finally (endBlock: Procedure) -> Done {
  def id:Number = timer.every(pauseTime)do{
     if(condition.apply) then {
        block.apply
     } else {
        timer.stop(id)
        endBlock.apply
     }
  }
}

// Repeatedly execute block while condition is true, pausing by pauseTime
// between iterations. 
method while(condition:BoolBlock) pauseVarying (timeBlock) do (block:Procedure)  -> Done {
  if(condition.apply)then {
     block.apply
     timer.after(timeBlock.apply) do {
         while (condition) pauseVarying (timeBlock) do (block)
     }
  }
}

// Repeatedly execute block for each value in range, pausing pauseTime between iterations.
// block should take a numeric value as a parameter
method for[[T]](range':Iterable[[T]]) pausing (pauseTime: Number) do (block:Block[[Number,Done]])-> Done {
  def it = range'.iterator
  while{it.hasNext} pausing (pauseTime) do {block.apply(it.next)}
}

// Repeatedly execute block for each value in range, pausing pauseTime between iterations.
// block should take a numeric value as a parameter
// when condition fails, execute endBlock.
method for[[T]] (range':Iterable[[T]]) pausing (pauseTime) do (block: Block[[Number,Done]])
             finally(endBlock:Block) -> Done {
  def it: Iterator[[T]] = range'.iterator
  while{it.hasNext} pausing (pauseTime) do {block.apply(it.next)}
         finally(endBlock)
}