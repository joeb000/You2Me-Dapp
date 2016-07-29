var logevent = inquire.Logging();
logevent.watch(function(error, result){
   if (!error){
     console.log("*******************************************************");
     console.log("ID:" + result.args._output + " paid out: " + result.args._seekerOrProvider);
     console.log("*******************************************************");
   }
   else {
     console.log("oops something went wrong...")
   }
});
