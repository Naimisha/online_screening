var App= angular.module('Question', ["ui.bootstrap"]);

App.controller('QuestionCtrl', ['$scope', '$http', '$timeout', function($scope, $http, $timeout) {

	$scope.questions = [];
	$scope.answer=null;
	$scope.given_answer=[];
	$scope.len=0;
	$scope.answerded=[];
	$scope.ip_addr = "";
	$scope.loadTest = function(){
		$http.get('http://'+$scope.ip_addr+':3000/answer_sheets.json').success(function(data){
			

	     	$scope.questions = angular.fromJson(data.answer);
	     	$scope.displayQuestion();
	       	
	       	var result= data.result;
	        for(i=0;i<result.length;i++){
	       	     if(result[i]["answer"]==""){
	       			$scope.answerded[i]=false;       		
	       		}
	       		else
	       		{
	       			var tmp=angular.fromJson(result[i]["answer"]);
	       			
	       			var j=0;
	       			for(j=0;j<tmp.length;j++){
	       				if(tmp[j]["ans"]!="#" && tmp[j]["ans"]!=""){
	       					$scope.answerded[i]=true;
	       					break;
	       				}
	       			}
	       			if(j==tmp.length)
	       				$scope.answerded[i]=false
	       		}
	       	}

	    //	document.write(typeof $scope.answerded[0]);     	

	     }).error(function(){
			document.write("error in loading exam");
		});
 	};


    $scope.question_no =0;
	
	$scope.quest= [];
	$scope.options = [];
	$scope.question_type="";
	
	$scope.initParam= function(countdown,ip){
		$scope.countdown = parseInt(countdown);
		$scope.ip_addr = ip;
		
		if($scope.countdown>0)
		{
			$scope.start_timer();
			$scope.loadTest();
		}
		else{
			window.location.replace("http://"+$scope.ip_addr+":3000/answer_sheets/result.html");
			//$http.get("http://"+$scope.ip_addr+":3000/answer_sheets/result.html").success(function(){
			//	window.location.replace("http://"+$scope.ip_addr+":3000/answer_sheets/result.html");
			//});
		}

	}

	$scope.start_timer = function(){
		//var c = parseInt(countdown);
		
		if($scope.countdown-- >0)
		{
			var m = parseInt($scope.countdown/60);
			var s = $scope.countdown%60;
			var timer = document.getElementById("timer");;
			if(timer != null)
			{
				var str = m + ':' + s;
				timer.innerHTML = str;
			}
			
			setTimeout($scope.start_timer, 1000);
		}
		else
			$http.get("http://"+$scope.ip_addr+":3000/answer_sheets/result.html");

	};

	$scope.setQuestionNo= function(qno){
		$scope.question_no=qno;
		
		$scope.displayQuestion();
	};

	$scope.displayQuestion= function(){

		$http.get('http://'+$scope.ip_addr+':3000/questions/'+ $scope.questions[$scope.question_no].question_id + '.json').success(function(q){
			$scope.current_question= angular.fromJson(q);
			$scope.quest=$scope.current_question.question;
			$scope.options = $scope.getOptions();
			$scope.question_type = $scope.current_question.qtype;
			$scope.image = $scope.current_question.image;
			$scope.question_weightage = $scope.current_question.weightage;
			if($scope.question_type == "multi")
			{
				for(i=0; i<$scope.options.length ; i++)
					$scope.given_answer[i] = "#"
			}
            else
            	$scope.answer=null;
			$scope.getAnswer();



		}).error(function(){
		   document.write("error in displayQuestion");
	});
	
	};
	

	$scope.getOptions = function(){
		return angular.fromJson($scope.current_question.options);			
	};

	$scope.isFirstQuestion = function(){
		return $scope.question_no==0;
	};
	
	$scope.isLastQuestion = function(){
		return $scope.question_no==$scope.questions.length-1;
	};


	$scope.submitAnswer=function(){
		var result;
		if($scope.question_type == "mcq")
		{	
			if($scope.answer != null)
			{
				$scope.answerded[$scope.question_no]=true;
				result="{\"question_id\":\""+$scope.current_question.id+"\", \"answer\":\"[{\\\"ans\\\":\\\""+$scope.answer+"\\\"}]\"}";
			}
			else
			{
				$scope.answerded[$scope.question_no]=false;
				result="{\"question_id\":\""+$scope.current_question.id+"\", \"answer\":\"[{\\\"ans\\\":\\\"\\\"}]\"}";
			}
		}		
		else if($scope.question_type=="numerical") {
			//document.write($scope.answer);
			var value=document.getElementById('ans').value;
			if(value=="")
				$scope.answerded[$scope.question_no]=false;
			else
				$scope.answerded[$scope.question_no]=true;
			result="{\"question_id\":\""+$scope.current_question.id+"\", \"answer\":\"[{\\\"ans\\\":\\\""+value+"\\\"}]\"}";
		}
		else if($scope.question_type == "multi")
		{	
			var str="[";
			var i=0;
			var hash_count=0;
			for(i=0;i<$scope.given_answer.length-1;i++)
			{
				if($scope.given_answer[i]=="#")
					hash_count++;
				str+="{\\\"ans\\\":\\\""+$scope.given_answer[i]+"\\\"},";
			}
			str+="{\\\"ans\\\":\\\""+$scope.given_answer[i]+"\\\"}]";
			if($scope.given_answer[i]=="#")
				hash_count++;

			if(hash_count==$scope.given_answer.length){
				$scope.answerded[$scope.question_no]=false;
				//document.write($scope.answerded[$scope.question_no])
			}
			else
				$scope.answerded[$scope.question_no]=true;



			result="{\"question_id\":\""+$scope.current_question.id+"\", \"answer\":\""+str+"\"}";				
		}
		if($scope.answer == "" && $scope.question_type =="mcq")
		{
			
			$scope.answerded[$scope.question_no]=false;
		}
		

		$http.post('http://'+$scope.ip_addr+':3000/answer_sheets/'+$scope.question_no+'/update_result.json', {answer:result}).success(function(data){}).error(function(){ document.write("error in submitAnswer")});
		
		if(!$scope.isLastQuestion())
		{
			$scope.question_no+=1;
			$scope.displayQuestion();
		}			
	};

	$scope.decrementQuestionNo=function(){
		$scope.question_no-=1;
		$scope.displayQuestion();
	};

	$scope.incrementQuestionNo=function(){
		
		$scope.question_no+=1;
		$scope.displayQuestion();
	};

	$scope.getAnswer=function(){
    
	$http.get('http://'+$scope.ip_addr+':3000/answer_sheets/'+$scope.question_no+'/get_answer.json').success(function(data){
		
		//document.write(data[0]["ans"]);
		if(data != ""){
			if($scope.question_type != "multi")
			{
				
				$scope.answer= data[0]["ans"];
				if($scope.answer=="")
					$scope.answerded[$scope.question_no]=false
				else
					$scope.answerded[$scope.question_no]=true;
			}
			else if($scope.question_type=="multi")
			{
				var hash_count=0;
				for(var i=0;i<data.length;i++)
				{	
					$scope.given_answer[i]=data[i]["ans"];
					if($scope.given_answer[i]!="#"){
						$scope.answerded[$scope.question_no]=true;						
					}
					else{
						hash_count++;
					}
				}
				if(hash_count==data.length)
					$scope.answerded[$scope.question_no]=false;


			}
		}
		else{
			$scope.answerded[$scope.question_no]=false;
			$scope.answer = null;
		}		
     }).error(function(){
		document.write("error in getAnswer");
	});
	};
	

	$scope.setAnswer=function(value)
	{
		
		$scope.answer=value;

	};

	$scope.isAnswered=function($index)
	{
		//document.write($scope.answerded[$index]);
		return $scope.answerded[$index];
	}

	$scope.clearResponse=function(){
		//document.getElementById('ans').checked = false;
		$scope.answer="";
	};

}] );




App.controller('ReviewCtrl',['$scope','$http',function($scope,$http){
		$scope.reviewTest=function(){

			$http.post('http://'+$scope.ip_addr+':3000/answer_sheets/display_test.json',{test:'test'}).success(function(data){
				$scope.review_paper=angular.fromJson(data);
				$scope.answers=new Array($scope.review_paper.length);
				 
				for (var i =0; i <= $scope.review_paper.length;i++) {
					$scope.answers[i] = ($scope.review_paper[i]["answer"]).split(",");
					 var tmp=[];
					 var k=0;

					for(var j=0; j<$scope.answers[i].length;j++){

						if($scope.answers[i][j] != "#")
							tmp[k++] = $scope.answers[i][j];
					}
					$scope.answers[i] = tmp;
				}
			
				document.write($scope.answers[0]);


		}).error(function(){document.write("error display_test");});
		};
		$scope.initParam=function(ip){
			$scope.ip_addr=ip;
		};
		

}]);

App.controller('OptionCtrl', ['$scope', function($scope) {
	$scope.checkAns = [];
	$scope.optionVal = [];
	$scope.qtype = "mcq";
	$scope.nooptions = 1;
	$scope.image = false;

	$scope.initOptions = function(options, answers, qtype, image){
		if(options != '' && answers != '' && qtype != ''){
			optionsJsonObj = angular.fromJson(options);
			answersJsonObj = angular.fromJson(answers);
			$scope.nooptions = optionsJsonObj.length;
			answers = answersJsonObj.length;
			ansIndex = 0;
			for(i = 0; i < $scope.nooptions; i++){
				$scope.optionVal[i] = optionsJsonObj[i]["opt"];
				if(ansIndex < answers && optionsJsonObj[i]["opt"] == answersJsonObj[ansIndex]["ans"] ){
					ansIndex++;
					$scope.checkAns[i] = 1;
				}else{
					if(ansIndex < answers && answersJsonObj[ansIndex]["ans"] == "#")
						ansIndex++;
					$scope.checkAns[i] = 0;
				}
			}

			if(qtype != '')
				$scope.qtype = qtype;

			if(image != '')
				$scope.image = true;
		}
	};

	$scope.validateForm = function($event){
		for(i = 0; i < $scope.nooptions; i++){
			if($scope.optionVal[i] == ""){
				alert("Option/Answer field(s) cannot be empty.");
				$event.preventDefault();
				return;
			}
		}
	}

}] );

App.filter('range', function() {
  return function(input, total) {
    total = parseInt(total);
    for (var i=0; i<total; i++)
      input.push(i);
    return input;
  };
});


App.controller('QTypeCtrl', ['$scope','$http', function($scope, $http) {

	$scope.total_marks=0;
	$scope.no_weightages=1;
	$scope.weightages=[];
	$scope.no_questions_each_weightage=[];
	$scope.ip_addr = "";

	$scope.initParam = function(ip){
		$scope.ip_addr = ip;
	};

	$scope.calculate =function(){
		$scope.total_marks=0;
		for(i=0; i< $scope.no_weightages; i++){
			if(undefined != $scope.weightages[i] && undefined != $scope.no_questions_each_weightage[i]){
			$scope.total_marks = $scope.total_marks + ($scope.weightages[i] * $scope.no_questions_each_weightage[i]);
			}
			}
		return $scope.total_marks;	
		};

	$scope.initWeightages= function(no_weightages, weightages, no_questions_each_weightage, selected_question_ids, max_id){
		$scope.selectedq = new Array(parseInt(max_id));
		if(no_weightages != null && weightages != '' && no_questions_each_weightage != '' && selected_question_ids.length>0){
			$scope.no_weightages=parseInt(no_weightages);
			weightages_JsonObj=angular.fromJson(weightages);
			no_questions_each_weightage_JsonObj=angular.fromJson(no_questions_each_weightage);

			for(i=0;i<no_weightages;i++){
				$scope.weightages[i]=parseInt(weightages_JsonObj[i]["weightage"]);
				$scope.no_questions_each_weightage[i]=parseInt(no_questions_each_weightage_JsonObj[i]["no_questions"]);
			}

			for(i=0;i<selected_question_ids.length; i++){
				$scope.selectedq[selected_question_ids[i]-1]=selected_question_ids[i].toString();

			}
			for(i=0;i<selected_question_ids.length; i++){
				//document.write($scope.selectedq[i]);
				//document.write("<br/>");

			}


		}


	};

	$scope.validate=function($event, e){
		
		var flag=true;
		flag=$scope.validateExamQuestion($event, e, flag);
		if(flag){
			$scope.createJson($event, e);
		}
	};

	$scope.validateExamQuestion=function($event, e, flag){
		if(undefined == $scope.no_weightages || $scope.no_weightages == 0){
			alert(" Weightage field(s) cannot be empty");
			flag=false;					
			$event.preventDefault();
			return flag;

		}
		else{
			for(var i=0; i< $scope.no_weightages; i++){
				if(undefined == $scope.weightages[i] || undefined == $scope.no_questions_each_weightage[i] ){
					alert("Weightage and Number of Questions per Weightage field(s) cannot be empty");
					flag=false;			
					$event.preventDefault();
					return flag;
				}
			}
		}
		return flag;


		
	};/*
	selectedq_JsonObj='[';
	$scope.createJson=function($event){
			for(var i=0; i<$scope.selectedq.length; i++){
				if($scope.selectedq[i] != "false"){
					selectedq_JsonObj+='{"'+(i+1)+'":"' + $scope.selectedq[i] + '"},';	
				}
			}
			selectedq_JsonObj = selectedq_JsonObj.substr(0, selectedq_JsonObj.length-1);
			selectedq_JsonObj += ']';
			document.write(selectedq_JsonObj);
			$event.preventDefault();

		}; */


	selectedq_JsonObj='[';
	weightages_json='[';
	no_questions_each_weightage_json='[';
	$scope.createJson=function($event,e){

 		for(var i=0; i<$scope.no_weightages; i++){
 			 weightages_json += '{"weightage":"' + $scope.weightages[i] + '"},';
 			 no_questions_each_weightage_json += '{"no_questions":"' + $scope.no_questions_each_weightage[i] + '"},';
 		}
 		weightages_json=weightages_json.substr(0, weightages_json.length-1);
        no_questions_each_weightage_json=no_questions_each_weightage_json.substr(0, no_questions_each_weightage_json.length-1);
        weightages_json += ']';
        no_questions_each_weightage_json += ']';
		for(var i=0; i<$scope.selectedq.length; i++){
			if($scope.selectedq[i] != "false" && undefined != $scope.selectedq[i]){
				selectedq_JsonObj+='{"selectedq":"' + $scope.selectedq[i] + '"},';	
			}
		}
		selectedq_JsonObj = selectedq_JsonObj.substr(0, selectedq_JsonObj.length-1);
		selectedq_JsonObj += ']';
		//document.write(selectedq_JsonObj);
		//document.write("<br/>");
		//document.write(weightages_json);
		//document.write("<br/>");
		//document.write(no_questions_each_weightage_json);
		//document.write("<br/>");
		//document.write("hello");
		//document.write(e);

		parameters='[{"no_weightages": '+ $scope.no_weightages +'}, {"weightages": ' +weightages_json+ '}, {"no_questions_each_weightage": ' +no_questions_each_weightage_json+ '}, {"selectedque": '+selectedq_JsonObj+ '}, {"total_marks": ' +$scope.total_marks+ '}]';
		//document.write(parameters);
		$http.post('http://'+$scope.ip_addr+':3000/exam_questions/'+e+'/save_exam_questions.json', {params: parameters}).success(function(data){
				if(data=="true"){
					window.location.replace("/exam_questions/"+e+"/view_exam_questions.html");
				}
				else
				{
					window.location.replace("/exams/"+e+"/set_questions");
				}
			});
		
	};


}]);



App.controller('AdminCntrl', ['$scope', '$modal', '$http' , '$log', function($scope ,$modal, $http , $log) {
	$scope.tab = 1;
	$scope.ip_addr=""
	$scope.user_data = [];

    //document.write($scope.user_data);
    $scope.initIP=function(ip)
    {
    	$scope.ip_addr=ip;
    }

	$scope.selectTab = function(setTab){
		//document.write("hello pratik1");
		$scope.tab = setTab;
	};

	$scope.isSelected = function(checkTab){
		//document.write("hello pratik");
		return $scope.tab === checkTab;
	};

	$scope.getuserData = function(){
		$http.get('http://'+$scope.ip_addr+':3000/admins.json').success(function(data){

	      $scope.user_data = data;
	     }).error(function(){
			document.write("error in admin");
		});
	};

	// $scope.addAdmin = function(user_id){
	//  $scope.id = user_id;
	//  $http.post('http://localhost:3000/admins/'+ $scope.id + '/addAdmin.json' , {uid_cnt: user_id}).success(function(data){}).error(function(){ document.write("error in add admin")});
	// };

  $scope.open = function (usr) {
  	
    var modalInstance = $modal.open({
      templateUrl: 'myModalContent.html',
      controller: 'ModalInstanceCtrl',
      size: 'sm',
      resolve: {
        usr_fun: function () {
          return usr;
        }
      }
    });

    modalInstance.result.then(function (user_id) {
     $scope.id = user_id;
	 $http.post('http://'+$scope.ip_addr+':3000/admins/'+ $scope.id + '/addAdmin.json' , {uid_cnt: user_id}).success(function(data){ location.reload();}).error(function(){ document.write("error in add admin")});
    });
  };

} ]);





App.controller('ModalInstanceCtrl', function ($scope, $modalInstance, usr_fun) {

  $scope.to_add_admin = usr_fun;

  $scope.ok = function () {
    $modalInstance.close($scope.to_add_admin.id);
  };

  $scope.cancel = function () {
    $modalInstance.dismiss('cancel');
  };


});

App.controller('printCtrl',['$scope', function($scope){

	$scope.printResult = function(){
		var select_exam = document.getElementById('select_exam');
		var shortlist_criteria = document.getElementById('shortlist_criteria');
		select_exam.style.display = "none";
		shortlist_criteria.style.display = "none";
		window.print();
		select_exam.style.display = "block";
		shortlist_criteria.style.display = "block";
		/*var toPrint = document.getElementById('print');
		var popupWin = window.open('');
		popupWin.document.open();
		popupWin.document.write('<html><head><link rel="stylesheet" type="text/css" href="/home/harshit/RailsWorkspace/online_screening_final/app/assets/stylesheets"></head><body onLoad=""> '+ toPrint.innerHTML + '</body></html>');
		alert('<html><head><link rel="stylesheet" type="text/css" href="/home/harshit/RailsWorkspace/online_screening_final/app/assets/stylesheets"></head><body onLoad=""> '+ toPrint.innerHTML + '</body></html>');
		popupWin.document.close();*/

	};
}]);