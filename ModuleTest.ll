source_filename = "ModuleTest.ego"
define i32 @factorial(i32 %n) nounwind {
  %1 = icmp sle i32 %n, 1
  br i1 %1, label %2, label %3

  ; <label>:2
  br label %7

  ; <label>:3
  %4 = sub i32 %n, 1
  %5 = call i32 @factorial(i32 %4)
  %6 = mul i32 %n, %5
  br label %7

  ; <label>:7
  %8 = phi i32 [1, %2], [%6, %3]
  ret i32 %8
}
