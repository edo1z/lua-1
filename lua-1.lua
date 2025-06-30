local x = 10
local y = 30

print(x)

if y > x then
  y = y - x
end

print(y)

while x > 0 do
  x = x - 1
  print(x)
end

for i = 0, 10, 2 do
  print(i)
end

local dict = {
  name = "taro",
  age = 38,
  ["multi word"] = "hanage"
}

print(dict.age)
print(dict["age"])

for k,v in pairs(dict) do
  print(k, v)
end

local function add(a, b)
  return a + b
end

print(add(1,3))


local function counter()
    local count = 0
    return function()
        count = count + 1
        return count
    end
end

local c = counter()

print(c())
print(c())
