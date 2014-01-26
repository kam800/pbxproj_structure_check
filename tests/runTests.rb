PBXPROJ_STRUCTURE_CHECK_BIN="../pbxproj_structure_check.rb"

def test_project(params, expected_text, expected_code)
  puts "Testing #{params}..."
  text_invocation = ""
  result_text =`ruby #{PBXPROJ_STRUCTURE_CHECK_BIN} #{params} 2>&1`.strip
  result_code = $?.exitstatus

  if (not result_text.eql? expected_text) or (not result_code.eql? expected_code)
    abort "FAILED! Expected\n  \##{expected_code}:'#{expected_text}'\nbut got\n  \##{result_code}:'#{result_text}'"
  else
    puts "OK"
  end
end

puts "Testing negative cases..."

test_project("negativeCases/absolutePath", "Object 'D44337F8189543F300D1A9D4' named 'AppDelegate.m' at '/StructureTestApp' is not relative to <group> but to <absolute>", 1)
test_project("negativeCases/buildPath", "Object 'D44337F8189543F300D1A9D4' named 'AppDelegate.m' at '/StructureTestApp' is not relative to <group> but to BUILT_PRODUCTS_DIR", 1)
test_project("negativeCases/developerPath", "Object 'D44337F8189543F300D1A9D4' named 'AppDelegate.m' at '/StructureTestApp' is not relative to <group> but to DEVELOPER_DIR", 1)
test_project("negativeCases/fakeGroup", "Object 'D4433817189545E500D1A9D4' named 'FakeGroup' at '/StructureTestApp' has no physical path", 1)
test_project("negativeCases/fakeSubGroup", "Object 'D4433817189545E500D1A9D4' named 'FakeGroup' at '/StructureTestApp' has no physical path", 1)
test_project("negativeCases/misnamedGroup", "Object 'D4433817189545E500D1A9D4' named 'FakeGroup2' at '/StructureTestApp' has name 'FakeGroup2' different from its real path 'FakeGroup'", 1)
test_project("negativeCases/projectPath", "Object 'D44337F8189543F300D1A9D4' named 'AppDelegate.m' at '/StructureTestApp' is not relative to <group> but to SOURCE_ROOT", 1)
test_project("negativeCases/realSubGroup", "Object 'D4433817189545E500D1A9D4' named 'FakeGroup' at '/StructureTestApp' has no physical path", 1)
test_project("negativeCases/sdkPath", "Object 'D44337F8189543F300D1A9D4' named 'AppDelegate.m' at '/StructureTestApp' is not relative to <group> but to SDKROOT", 1)
test_project("negativeCases/subGroup", "Object 'D44337F7189543F300D1A9D4' named 'AppDelegate.h' at '/StructureTestApp/FakeGroup' has name 'AppDelegate.h' different from its real path '../AppDelegate.h'", 1)
test_project("negativeCases/superGroup", "Object 'D44337F7189543F300D1A9D4' named 'AppDelegate.h' at '/' has name 'AppDelegate.h' different from its real path 'StructureTestApp/AppDelegate.h'", 1)

puts "Testing positive cases..."

test_project("positiveCases/simpleOK D44337EF189543F300D1A9D4:D4433808189543F400D1A9D4:D44337E7189543F300D1A9D4:D44337E6189543F300D1A9D4", "", 0)
test_project("positiveCases/subGroupOK D44337EF189543F300D1A9D4:D4433808189543F400D1A9D4:D44337E7189543F300D1A9D4:D44337E6189543F300D1A9D4", "", 0)