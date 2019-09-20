# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Seabolt17 < Formula
  desc "Neo4j Bolt Connector for C"
  homepage "https://github.com/neo4j-drivers/seabolt"
  url "https://github.com/neo4j-drivers/seabolt/archive/v1.7.4.tar.gz"
  sha256 "f51c02dfef862d97963a7b67b670750730fcdd7b56a11ce87c8c1d01826397ee"
  head "https://github.com/neo4j-drivers/seabolt", :branch => "1.7"

  depends_on "cmake" => :build
  depends_on "pkg-config"
  depends_on "openssl" => [:build, :test]

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel
    # Remove unrecognized options if warned by configure
    system "cmake", ".", *std_cmake_args
    system "make", "install" # if this fails, try separate make/make install steps
  end

  test do
    (testpath/"CMakeLists.txt").write(%{
      cmake_minimum_required(VERSION 3.11 FATAL_ERROR)

      project(seabolt17-test
        DESCRIPTION "Seabolt17 Install Test"
        LANGUAGES C)

      add_executable(seabolt17-test main.c)

      find_package(seabolt17 REQUIRED)
      target_link_libraries(seabolt17-test seabolt17::seabolt-shared)
    })

    (testpath/"main.c").write(%{
       #include <stdio.h>
       #include <string.h>
       #include <bolt/bolt.h>
       
       int main(int argc, char** argv) {
           Bolt_startup();
           Bolt_shutdown();
           return 0;
       } 
    })

    system "cmake", "--build", "."
  end
end
