FROM openjdk:8
ADD jarstaging/com/valaxy/demo-workshop/2.1.3/demo-workshop-2.1.3.jar tweettrend.jar
ENTRYPOINT ["java" , "-jar" , "tweettrend.jar"]
