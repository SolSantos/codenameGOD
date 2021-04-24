-- Forces that a number will not exceed a min and max values
function clamp(num, min, max)
	if num > max then
		num = max
	elseif num < min then
		num = min
	end
	return num
end

return {
	clamp=clamp
}