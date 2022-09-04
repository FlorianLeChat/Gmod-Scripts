local function TasksDeleteAll()
	for _, v in ipairs(file.Find("tasks/settings/*", "DATA")) do
		file.Delete("tasks/settings/" .. v)
	end

	for _, v in ipairs(file.Find("tasks/data/*", "DATA")) do
		file.Delete("tasks/data/" .. v)
	end

	--	for _, v in ipairs(file.Find("tasks/lists/*", "DATA")) do
	--		file.Delete("tasks/lists/" .. v)
	--	end

	Derma_Message("Tasks a été réinitialisé avec succès !", "Information", "OK")
end

local function GetTitle()
	if file.Read("tasks/settings/default_title.txt") != nil then
		return file.Read("tasks/settings/default_title.txt")
	else
		return "Titre du texte.."
	end
end

local function GetBody()
	if file.Read("tasks/settings/default_body.txt") != nil then
		return file.Read("tasks/settings/default_body.txt")
	else
		return "Corps du texte.."
	end
end

local function TasksPanel()
	file.CreateDir("tasks")
	file.CreateDir("tasks/settings")
	file.CreateDir("tasks/data")
	--	file.CreateDir("tasks/lists")

	local num1 = #file.Find("tasks/data/*", "DATA")
	--	local num2 = #file.Find("tasks/lists/*", "DATA")

	local editing = false
	local editId = 0

	local Panel = vgui.Create("DFrame")
	Panel:SetSize(ScrW() - 100, ScrH() - 100)
	Panel:SetTitle("Tasks")
	Panel:ShowCloseButton(true)
	Panel:SetDraggable(true)
	Panel:Center()
	Panel:MakePopup()

	local MenuBar = vgui.Create("DMenuBar", Panel)
	MenuBar:DockMargin(-3, -5, -3, 2)

	local Menu1 = MenuBar:AddMenu("Menu")
	--	local Menu2 = MenuBar:AddMenu("Listes")
	local Menu3 = MenuBar:AddMenu("Valeurs par défaut")

	local Main = vgui.Create("DPropertySheet", Panel)
	Main:Dock(FILL)
	Main:DockMargin(0, 0, Panel:GetWide() / 2, 0)

	local PanelDefault = vgui.Create("DPanel", Main)
	Main:AddSheet("Liste par défaut", PanelDefault, "icon16/user.png")

	local DScrollPanel = vgui.Create("DScrollPanel", PanelDefault)
	DScrollPanel:Dock(FILL)

	local TextEntry1 = vgui.Create("DTextEntry", Panel)
	TextEntry1:Dock(FILL)
	TextEntry1:DockMargin(Panel:GetWide() / 2, 0, 0, Panel:GetTall() - 80)
	TextEntry1:SetText(GetTitle())
	TextEntry1:SetFont("Trebuchet18")

	local TextEntry2 = vgui.Create("DTextEntry", Panel)
	TextEntry2:Dock(FILL)
	TextEntry2:DockMargin(Panel:GetWide() / 2, 25, 0, 50)
	TextEntry2:SetText(GetBody())
	TextEntry2:SetFont("Trebuchet24")
	TextEntry2:SetMultiline(true)

	local function AddButton(name, parent, func)
		local Button = parent:Add("DButton")
		Button:SetText(name)
		Button:Dock(TOP)
		Button:SetIcon("icon16/arrow_right.png")
		Button.DoClick = func
		Button:SetTooltip("Pour supprimer la tâche, veuillez double-cliquer sur celle-ci.")
		Button.DoDoubleClick = function(self)
			self:Remove()

			file.Write("tasks/data/file_" .. string.match(self:GetText(), "#(.+)") .. ".txt", "")
			file.Rename("tasks/data/file_" .. string.match(self:GetText(), "#(.+)") .. ".txt", "tasks/data/removed#" .. string.match(self:GetText(), "#(.+)") .. ".txt")

			Panel:Remove()
			TasksPanel()

			Derma_Message("Le fichier '" .. self:GetText() .. "' a été supprimé avec succès !", "Information", "OK")
		end
	end

	local Button = vgui.Create("DButton", Panel)
	Button:SetText("Ajouter la tâche dans la liste active")
	Button:Dock(FILL)
	Button:DockMargin(Panel:GetWide() / 2, Panel:GetTall() - 100, 0, 0)
	Button:SetIcon("icon16/tick.png")
	Button.DoClick = function()
		if not editing then
			num1 = num1 + 1

			file.Write("tasks/data/file_" .. num1 .. ".txt", TextEntry1:GetText() .. "|" .. TextEntry2:GetText())

			local content = string.Explode("|", file.Read("tasks/data/file_" .. num1 .. ".txt"))

			AddButton(TextEntry1:GetText() .. " #" .. num1, DScrollPanel, function()
				TextEntry1:SetText(content[1])
				TextEntry2:SetText(content[2])
				editing = true
				editId = num1
				Button:SetText("Sauvegarder les changements de la tâche")
			end)

			Derma_Message("Le fichier '" .. TextEntry1:GetText() .. "' a été ajouté avec succès !", "Information", "OK")

			TextEntry1:SetText(GetTitle())
			TextEntry2:SetText(GetBody())
		else
			file.Write("tasks/data/file_" .. editId .. ".txt", TextEntry1:GetText() .. "|" .. TextEntry2:GetText())

			Derma_Message("Le fichier '" .. TextEntry1:GetText() .. "' a été modifié avec succès !", "Information", "OK")

			Panel:Remove()
			TasksPanel()
		end
	end

	Menu1:AddOption("Rouvrir le menu", function()
		Panel:Remove()
		TasksPanel()
	end):SetIcon("icon16/arrow_rotate_clockwise.png")

	Menu1:AddOption("Fermer le menu", function()
		Panel:Remove()
	end):SetIcon("icon16/cross.png")

	Menu1:AddOption("Réinitialiser Tasks", function()
		Derma_Query(
			"Voulez-vous vraiment réinitialiser Tasks ?",
			"Réinitialisation de Tasks",
			"Oui", function()
				TasksDeleteAll()
				Panel:Remove()
			end,
			"Non", function() end
		)
	end):SetIcon("icon16/application.png")

	--[[
	Menu2:AddOption("Ajouter une liste", function()
		TextEntry1:SetText(GetTitle())
		TextEntry2:SetText(GetBody())

		Button:SetText("Ajouter la tâche dans la liste active")

		editing = false

		Derma_StringRequest(
			"Ajout d'une nouvelle liste",
			"Entrez le nom de la nouvelle liste ci-dessous",
			"",
			function(text)
				num2 = num2 + 1

				local PanelAdd = vgui.Create("DPanel", Main)
				Main:AddSheet(text .. " #" .. num2, PanelAdd, "icon16/user.png")

				file.Write("tasks/lists/list_" .. num2 .. ".txt", text)

				Derma_Message("La liste '" .. text .. "' a été ajoutée avec succès !", "Information", "OK")
			end
		)
	end):SetIcon("icon16/table_add.png")

	Menu2:AddOption("Renommer une liste", function()
		TextEntry1:SetText(GetTitle())
		TextEntry2:SetText(GetBody())

		Button:SetText("Ajouter la tâche dans la liste active")

		editing = false

		Derma_StringRequest(
			"Renommer une liste existante",
			"Entrez l'ID d'une liste déjà existante ci-dessous (Numéro après le #)",
			"",
			function(id)
				if file.Read("tasks/lists/list_" .. id .. ".txt") != nil then
					Derma_StringRequest(
						"Renommer une liste existante",
						"Entrez le nouveau nom de cette liste",
						"",
						function(text)
							file.Write("tasks/lists/list_" .. id .. ".txt", text)

							Panel:Remove()
							TasksPanel()

							Derma_Message("La liste " .. id .. " a été renomée avec succès en : '" .. text .. "' !", "Information", "OK")
						end
					)
				else
					Derma_Message("La liste " .. id .. " n'a pas pu être renommée car elle n'existe pas !", "Information", "OK")
				end
			end
		)
	end):SetIcon("icon16/textfield_rename.png")

	Menu2:AddOption("Supprimer une liste", function()
		TextEntry1:SetText(GetTitle())
		TextEntry2:SetText(GetBody())

		Button:SetText("Ajouter la tâche dans la liste active")

		editing = false

		Derma_StringRequest(
			"Supprimer une liste existante",
			"Entrez l'ID d'une liste déjà existante ci-dessous (Numéro après le #)",
			"",
			function(text)
				if file.Read("tasks/lists/list_" .. text .. ".txt") != nil then
					file.Write("tasks/lists/list_" .. text .. ".txt", "")
					file.Rename("tasks/lists/list_" .. text .. ".txt", "tasks/lists/removed#" .. text .. ".txt")

					Panel:Remove()
					TasksPanel()

					Derma_Message("La liste " .. text .. " a été supprimée avec succès !", "Information", "OK")
				else
					Derma_Message("La liste " .. text .. " n'a pas pu être supprimée car elle n'existe pas !", "Information", "OK")
				end
			end
		)
	end):SetIcon("icon16/table_delete.png")
	--]]

	Menu3:AddOption("Changer le titre par défaut", function()
		TextEntry1:SetText(GetTitle())
		TextEntry2:SetText(GetBody())

		Button:SetText("Ajouter la tâche dans la liste active")

		editing = false

		Derma_StringRequest(
			"Changement du titre par défaut",
			"Entrez le nouveau titre ci-dessous",
			"",
			function(text)
				TextEntry1:SetText(text)

				file.Write("tasks/settings/default_title.txt", text)

				Derma_Message("Le titre par défault est désormais : '" .. text .. "'.", "Information", "OK")
			end
		)
	end):SetIcon("icon16/textfield_rename.png")

	Menu3:AddOption("Changer le corps du texte par défaut", function()
		TextEntry1:SetText(GetTitle())
		TextEntry2:SetText(GetBody())

		Button:SetText("Ajouter la tâche dans la liste active")

		editing = false

		Derma_StringRequest(
			"Changement du corps du texte par défaut",
			"Entrez le nouveau corps du texte ci-dessous",
			"",
			function(text)
				TextEntry2:SetText(text)

				file.Write("tasks/settings/default_body.txt", text)

				Derma_Message("Le corps du texte par défault est désormais : '" .. text .. "'.", "Information", "OK")
			end
		)
	end):SetIcon("icon16/textfield_rename.png")

	Menu3:AddOption("Supprimer les paramètres personnalisés", function()
		for _, v in ipairs(file.Find("tasks/settings/*", "DATA")) do
			file.Delete("tasks/settings/" .. v)
		end

		TextEntry1:SetText("Titre du texte..")
		TextEntry2:SetText("Corps du texte..")

		Button:SetText("Ajouter la tâche dans la liste active")

		editing = false

		Derma_Message("Les paramètres personnalisés ont été réinitialisés avec succès !", "Information", "OK")
	end):SetIcon("icon16/cancel.png")

	for i = 1, num1 do
		if file.Read("tasks/data/file_" .. i .. ".txt") == nil then continue end

		local content = string.Explode("|", file.Read("tasks/data/file_" .. i .. ".txt"))

		AddButton(content[1] .. " #" .. i, DScrollPanel, function()
			TextEntry1:SetText(content[1])
			TextEntry2:SetText(content[2])
			editing = true
			editId = i
			Button:SetText("Sauvegarder les changements de la tâche")
		end)
	end

	--[[
	for i = 1, num2 do
		if file.Read("tasks/lists/list_" .. i .. ".txt") == nil then continue end

		local PanelAdd = vgui.Create("DPanel", Main)
		Main:AddSheet(file.Read("tasks/lists/list_" .. i .. ".txt") .. " #" .. i, PanelAdd, "icon16/user.png")
	end
	--]]

	Main.OnActiveTabChanged = function(old, new)
		for i = 1, num1 do
			if file.Read("tasks/data/file_" .. i .. ".txt") == nil then continue end

			local content = string.Explode("|", file.Read("tasks/data/file_" .. i .. ".txt"))

			AddButton(content[1] .. " #" .. i, DScrollPanel, function()
				TextEntry1:SetText(content[1])
				TextEntry2:SetText(content[2])
				editing = true
				editId = i
				Button:SetText("Sauvegarder les changements de la tâche")
			end)
		end
	end
end

hook.Add("OnPlayerChat", "TasksCommand", function(ply, text)
	if ply == LocalPlayer() and string.lower(text) == "/tasks" then
		TasksPanel()
		return true
	end
end)