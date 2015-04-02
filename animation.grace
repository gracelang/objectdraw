import "timer" as timer

// type of a block that takes no parameters and returns a boolean
type BoolBlock = {apply -> Boolean}
type NumberBlock = {apply -> Number}

// type of object that can simulate parallel animations
type Animator = {
   // Repeatedly execute block while condition is true
   while(condition:BoolBlock) pausing (pauseTime:Number) do (block:Block) -> Done

   // Repeatedly execute block while condition is true, pausing pauseTime between iterations
   // when condition fails, execute endBlock.
   while (condition:BoolBlock) pausing (pauseTime:Number) do (block:Block) 
                         finally(endBlock:Block) -> Done

   // Repeatedly execute block while condition is true
   // pausing variable amount of time (obtained by evaluating timeBlock) between iterations
   // when condition fails, execute endBlock.
   while(condition:BoolBlock) pauseVarying (timeBlock: NumberBlock) do (block:Block) -> Done

   // Repeatedly execute block while condition is true
   for<T> (rangeList:List<T>) pausing (pauseTime) do (block:Block<T,Done>) -> Done
 
   // Repeatedly execute block while condition is true
   // when condition fails, execute endBlock.
   for<T> (rangeList:List<T>) pausing (pauseTime) do (block:Block<T,Done>) finally (endBlock:Block) -> Done

}

// Repeatedly execute block while condition is true
method while(condition:BoolBlock) pausing (pauseTime:Number) do (block:Block) -> Done {
  def id:Number = timer.every(pauseTime)do{
     if(condition.apply) then {
        block.apply
     } else {
        timer.stop(id)
     }
  }
}

// Repeatedly execute block while condition is true, pausing by pauseTime
// between iterations. When condition fails, execute endBlock.
method while (condition:BoolBlock) pausing (pauseTime:Number) do (block:Block) 
                  finally(endBlock:Block) -> Done {
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
method while(condition:BoolBlock) pauseVarying (timeBlock) do (block:Block)  -> Done {
  if(condition.apply)then {
     block.apply
     timer.after(timeBlock.apply) do {
         while (condition) pauseVarying (timeBlock) do (block)
     }
  }
}

// Repeatedly execute block for each value in rangeList, pausing pauseTime between iterations.
// block should take a numeric value as a parameter
method for<T>(rangeList:List<T>) pausing (pauseTime: Number) do (block:Block<Number,Done>)-> Done {
  def it = rangeList.iterator
  while{it.havemore} pausing (pauseTime) do {block.apply(it.next)}
}

// Repeatedly execute block for each value in rangeList, pausing pauseTime between iterations.
// block should take a numeric value as a parameter
// when condition fails, execute endBlock.
method for<T> (rangeList:List<T>) pausing (pauseTime) do(block:Block<Number,Done>)
             finally(endBlock:Block) -> Done {
  def it:Iterator<T> = rangeList.iterator
  while{it.havemore} pausing (pauseTime) do {block.apply(it.next)}
         finally(endBlock)
}