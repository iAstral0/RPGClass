extends Control

@onready var charSprite = $Sprite
@onready var jobName = $JobName
@onready var jobDesc = $JobDescription
@onready var skillBox = $SkillBox
@onready var jobDropdown = $JobDropdown
var CSVPath = "res://CSV/class.csv"
var jobs = []
var jobSpriteFrames ={
	"1": 7,
	"2": 29,
	"3": 4
}

func _ready():
	loadCSV(CSVPath)
	populateDropdown()
	jobDropdown.connect("item_selected", Callable(self, "onJobSelected"))
	jobDropdown.select(0)
	updateJobInfo(0)

func loadCSV(path: String):
	jobs.clear()
	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		var lines = file.get_as_text().split("\n")
		file.close()
		for i in range(1, lines.size()):
			var line = lines[i].strip_edges()
			if line == "":
				continue
			
			var row = line.split(",", false, 3)
			if row.size() < 4:
				continue
			
			var jobData = {
				"id" = row[0].strip_edges(),
				"jobname" = row[1].strip_edges(),
				"description" = row[2].strip_edges(),
				"skills" = row[3].strip_edges()
			}
			jobs.append(jobData)
	else:
		print("Path not found")

func populateDropdown():
	jobDropdown.clear()
	for job in jobs:
		jobDropdown.add_item(job["jobname"])

func onJobSelected(index: int):
	updateJobInfo(index)

func joinArray(arr: Array, sep: String):
	var result = ""
	for i in range(arr.size()):
		result += arr[i]
		if i < arr.size() - 1:
			result += sep
	return result

func updateJobInfo(index: int):
	if index < 0 or index >= jobs.size():
		return
	var job = jobs[index]
	jobName.text = job["jobname"]
	jobDesc.text = job["description"]
	var skillsList = []
	for skill in job["skills"].split(";"):
		skill = skill.strip_edges()
		if skill != "":
			skillsList.append(skill)
	skillBox.text = "[center]" + "[u]" +"Skills\n" + "[/u]"+ joinArray(skillsList, " | ") + "[/center]"
	
	if jobSpriteFrames.has(job["id"]):
		var frameIndex = jobSpriteFrames[job["id"]]
		charSprite.frame = frameIndex
