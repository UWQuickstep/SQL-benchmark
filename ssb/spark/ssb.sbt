name := "SSBQueries"

version := "1.0"

scalaVersion := "2.11.0"

libraryDependencies += "org.apache.spark" %% "spark-core" % "2.0.1" % "provided"

libraryDependencies += "org.apache.spark" %% "spark-sql" % "2.0.1" % "provided"

libraryDependencies += "com.github.scopt" %% "scopt" % "3.4.0"

resolvers += Resolver.sonatypeRepo("public")
