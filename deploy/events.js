var seekerPaid = ytm.LogSeekerPaid();
seekerPaid.watch(function(error, result){
   if (!error){
     console.log("*******************************************************");
     console.log("Seeker (" + result.args.seeker + ") paid fee for provider (" + result.args.provider + ")");
     console.log("*******************************************************");
   }
   else {
     console.log("oops something went wrong...")
   }
});

var callCompleted = ytm.LogCallCompleted();
callCompleted.watch(function(error, result){
   if (!error){
     console.log("*******************************************************");
     console.log("Call completed between seeker (" + result.args.seeker + ") and provider (" + result.args.provider + ")");
     console.log("*******************************************************");
   }
   else {
     console.log("oops something went wrong...")
   }
});

var rewardSent = ytm.LogRewardSent();
rewardSent.watch(function(error, result){
   if (!error){
     console.log("*******************************************************");
     console.log("Provider (" + result.args.provider + ") reward paid. Amount:" + result.args.reward);
     console.log("*******************************************************");
   }
   else {
     console.log("oops something went wrong...")
   }
});

var rewardSent = ytm.LogRated();
rewardSent.watch(function(error, result){
   if (!error){
     console.log("*******************************************************");
     console.log("Provider (" + result.args.provider + ") recieved rating of:" + result.args.rating);
     console.log("*******************************************************");
   }
   else {
     console.log("oops something went wrong...")
   }
});
