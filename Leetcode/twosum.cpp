#include <vector>
#include <unordered_map>
using namespace std;

class Solution {
public:
    vector<int> twoSum(vector<int>& nums, int target) {
        unordered_map<int, int> lookup; // number -> index
        
        for (int i = 0; i < nums.size(); i++) {
            int complement = target - nums[i];
            
            // If complement already exists, return indices
            if (lookup.find(complement) != lookup.end()) {
                return {lookup[complement], i};
            }
            
            // Store current number and its index
            lookup[nums[i]] = i;
        }
        
        return {}; // guaranteed one solution, so this won't execute
    }
};