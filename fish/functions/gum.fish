# Defined in - @ line 2
function gum
	set temp_branch (_git_branch_name)
    git checkout master
    git pull
    git checkout $temp_branch
end
