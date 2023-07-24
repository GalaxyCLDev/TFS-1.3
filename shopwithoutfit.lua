--- CODIGO MODIFICADO POR WWW.VAGOSCLUB.CL
--- NO BORRES ESTA PARTE
--- GRACIAS ESPERO TE SIRVA

local SHOP_EXTENDED_OPCODE = 201
local SHOP_OFFERS = {}
local SHOP_CALLBACKS = {}
local SHOP_CATEGORIES = nil
local SHOP_BUY_URL = "https://api.whatsapp.com/send/?phone=56991525557&text&type=phone_number&app_absent=0" -- can be empty
local SHOP_AD = { -- can be nil
  --image = "http://www.vagosclub.cl/tiendajuego/bannervagosclubtienda.png",
  url = "http://www.vagosclub.cl",
  text = "Tienda Vagos 2023"
}


function init()
	SHOP_CATEGORIES = {}
	
	local premiumCategory = addCategory({
		type="item",
		item=ItemType(28378):getClientId(),
		name="Usuarios Premium/Vip/Item"
	})
   --premiumCategory.addItem(10, 3043, 100, "Crystal Coins", "Enoy Test Server!.")
   premiumCategory.addItem(1000, 28385, 1, "x 1 Tiro de Ruleta", "Suerte!!")
   premiumCategory.addItem(3500, 28385, 5, "x 5 Tiro de Ruleta", "Suerte!!")
   premiumCategory.addItem(5000, 10135, 1, "Cuenta VIP x10", "Te costara 3500 puntos por 10 dias")
   premiumCategory.addItem(7500, 10134, 1, "Cuenta VIP x30", "Te costara 5500 puntos por 30 dias")
   premiumCategory.addItem(10000, 10133, 1, "Cuenta VIP x90", "Te costara 8000 puntos por 90 dias")
   premiumCategory.addItem(10000, 12328, 1, "Recupera tu Estamina", "Te costara 17000 puntos por 1 Recarga de estamina")
   premiumCategory.addItem(25000, 28405, 1, "Experiencia X2", "Te costara 25000 puntos por 1 Doble Experiencia (DURACION 2 HRS)")
   
   local regenerationCategory = addCategory({
		type="item",
		item=ItemType(26845):getClientId(),
		name="Items/Raros/Especiales"
	})
	regenerationCategory.addItem(135000, 27802, 1, "Casco MagoMuerte", "Proteccion: Arm:929 LifeyManaLeech:12%.")
	regenerationCategory.addItem(135000, 27797, 1, "Armor MagoMuerte", "Proteccion: Arm:513, RegeneracionVida:15000(3Seg).")
	regenerationCategory.addItem(135000, 27798, 1, "Legs MagoMuerte", "Proteccion: Arm:528, ManaLeech:10%.")
	regenerationCategory.addItem(135000, 27799, 1, "Botas MagoMuerte", "Proteccion: Arm:521, +50 Velocidad, 15%Proteccion Energy.")
	regenerationCategory.addItem(135000, 28416, 1, "Libro MagoMuerte", "Proteccion: Def:514 LifeLeech:12% Sword:10 Dist:10 Magic:10.")
	regenerationCategory.addItem(135000, 27588, 1, "Varita MagoMuerte", "Rango:12 Efecto:Energia ATK:95000 MAX.")
	regenerationCategory.addItem(135000, 27591, 1, "Espada MagoMuerte ", "ATK: 497 DEF: 414")

	local outfitsCategory = addCategory({
    type="outfit",
    name="Skins Disponibles",
    outfit={
        mount=0,
        feet=114,
        legs=114,
        body=116,
        type=1697,
        auxType=0,
        addons=3,
        head=2,
        rotating=true
    }
	})
	    outfitsCategory.addOutfit(25000, {
        mount = 0,
        feet = 114,
        legs = 114,
        body = 116,
        type = 725,
        auxType = 0,
        addons = 0,
        head = 2,
        rotating = true
    }, "Skin Evoker Hombre", "Obten esta skin permanente.")
	    outfitsCategory.addOutfit(25000, {
        mount = 0,
        feet = 114,
        legs = 114,
        body = 116,
        type = 724,
        auxType = 0,
        addons = 0,
        head = 2,
        rotating = true
    }, "Skin Evoker Mujer", "Obten esta skin permanente.")
	    outfitsCategory.addOutfit(35000, {
        mount = 0,
        feet = 114,
        legs = 114,
        body = 116,
        type = 1606,
        auxType = 0,
        addons = 0,
        head = 2,
        rotating = true
    }, "Skin Gengar", "Obten esta skin permanente.")
	    outfitsCategory.addOutfit(35000, {
        mount = 0,
        feet = 114,
        legs = 114,
        body = 116,
        type = 986,
        auxType = 0,
        addons = 0,
        head = 2,
        rotating = true
    }, "Skin Blastoise", "Obten esta skin permanente.")	
	
	local scrollsCategory = addCategory({
		type="item",
		item=ItemType(2140):getClientId(),
		name="EXP/Reventables"
	})
	scrollsCategory.addItem(155500, 2140, 36, "HolyScarab x36", "Compra 1 mochila de 36 Holy! (DEBES TENER LAS MOCHILAS VACIAS)")
	scrollsCategory.addItem(272000, 2366, 36, "Pluma x36", "Compra 1 mochila de 36 Pluma! (DEBES TENER LAS MOCHILAS VACIAS)")
	
	local trainingoffline = addCategory({
		type="item",
		item=ItemType(1957):getClientId(),
		name="Criticos"
	})
	trainingoffline.addItem(15000, 27195, 1, "Botella Critico +20%", "Atencion: Duracion 60 Minutos, Si mueres o Te Desconectas pierdes tu bufo")
	trainingoffline.addItem(15000, 26339, 1, "Botella ManaLeech +20%", "Atencion: Duracion 60 Minutos, Si mueres o Te Desconectas pierdes tu bufo")
	trainingoffline.addItem(15000, 27045, 1, "Botella LifeLeech +20%", "Atencion: Duracion 60 Minutos, Si mueres o Te Desconectas pierdes tu bufo")
	
	local toolsCategory = addCategory({
		type="item",
		item=ItemType(27083):getClientId(),
		name="Set Imbuido"
	})
	toolsCategory.addItem(155000, 27333, 1, "Bandana Ninja Fuego","2% Mana Leech")
	toolsCategory.addItem(155000, 27334, 1, "Amor Ninja Fuego","4% Mana Leech")
	toolsCategory.addItem(155000, 27335, 1, "Legs Ninja Fuego","2% Mana Leech")
	toolsCategory.addItem(155000, 27336, 1, "Botas Ninja Fuego","2% Mana Leech")
	
end

function addCategory(data)
  data['offers'] = {}
  table.insert(SHOP_CATEGORIES, data)
  table.insert(SHOP_CALLBACKS, {})
  local index = #SHOP_CATEGORIES
  return {
    addItem = function(cost, itemId, count, title, description, callback)      
      if not callback then
        callback = defaultItemBuyAction
      end
      table.insert(SHOP_CATEGORIES[index]['offers'], {
        cost=cost,
        type="item",
        item=ItemType(itemId):getClientId(), -- displayed
        itemId=itemId,
        count=count,
        title=title,
        description=description
      })
      table.insert(SHOP_CALLBACKS[index], callback)
    end,
    addOutfit = function(cost, outfit, title, description, callback)
      if not callback then
        callback = defaultOutfitBuyAction
      end
      table.insert(SHOP_CATEGORIES[index]['offers'], {
        cost=cost,
        type="outfit",
        outfit=outfit,
        title=title,
        description=description
      })    
      table.insert(SHOP_CALLBACKS[index], callback)
    end,
    addImage = function(cost, image, title, description, callback)
      if not callback then
        callback = defaultImageBuyAction
      end
      table.insert(SHOP_CATEGORIES[index]['offers'], {
        cost=cost,
        type="image",
        image=image,
        title=title,
        description=description
      })
      table.insert(SHOP_CALLBACKS[index], callback)
    end,
	addPremiumDays = function(cost, image, title, description, count, callback)
      if not callback then
        callback = defaultPremiumBuyAction
      end
      table.insert(SHOP_CATEGORIES[index]['offers'], {
        cost=cost,
        type="image",
        image=image,
        title=title,
        description=description,
		count=count,
      })
      table.insert(SHOP_CALLBACKS[index], callback)
    end
  }
end

function getPoints(player)
  local points = 0
  local resultId = db.storeQuery("SELECT `points` FROM `znote_accounts` WHERE `id` = " .. player:getAccountId())
  if resultId ~= false then
    points = result.getDataInt(resultId, "points")
    result.free(resultId)
  end
  return points
end

function getStatus(player)
  local status = {
    ad = SHOP_AD,
    points = getPoints(player),
    buyUrl = SHOP_BUY_URL
  }
  return status
end

function sendJSON(player, action, data, forceStatus)
	local status = nil
	if not player:getStorageValue(1150001) or player:getStorageValue(1150001) + 10 < 	os.time() or forceStatus then
      status = getStatus(player)
	end
	player:setStorageValue(1150001, os.time())

	local msg = NetworkMessage()
	msg:addByte(50)
	msg:addByte(SHOP_EXTENDED_OPCODE)
	msg:addString(json.encode({action = action, data = data, status = status}))
	msg:sendToPlayer(player)
end

function sendMessage(player, title, msg, forceStatus)
  sendJSON(player, "message", {title=title, msg=msg}, forceStatus)
end

function onExtendedOpcode(player, opcode, buffer)
	if opcode ~= SHOP_EXTENDED_OPCODE then
		return false
	end
  
	local status, json_data = pcall(function() return json.decode(buffer) end)
	if not status then
		return false
	end

	local action = json_data['action']
	local data = json_data['data']
	if not action or not data then
		return false
	end

	if SHOP_CATEGORIES == nil then
		init()    
	end

	if action == 'init' then
		sendJSON(player, "categories", SHOP_CATEGORIES)
	elseif action == 'buy' then
		processBuy(player, data)
	elseif action == "history" then
		sendHistory(player)
	end
return true
end

function processBuy(player, data)
  local categoryId = tonumber(data["category"])
  local offerId = tonumber(data["offer"])
  local offer = SHOP_CATEGORIES[categoryId]['offers'][offerId]
  local callback = SHOP_CALLBACKS[categoryId][offerId]
  if not offer or not callback or data["title"] ~= offer["title"] or data["cost"] ~= offer["cost"] then
    sendJSON(player, "categories", SHOP_CATEGORIES) -- refresh categories, maybe invalid
    return sendMessage(player, "Error!", "Oferta Invalida")      
  end
  local points = getPoints(player)
  if not offer['cost'] or offer['cost'] > points or points < 1 then
    return sendMessage(player, "Error!", "No tienes puntos suficientes para comprar " .. offer['title'] .."!", true)    
  end
  local status = callback(player, offer)
  if status == true then    
    db.query("UPDATE `znote_accounts` set `points` = `points` - " .. offer['cost'] .. " WHERE `id` = " .. player:getAccountId())
    db.asyncQuery("INSERT INTO `shop_history` (`account`, `player`, `date`, `title`, `cost`, `details`) VALUES ('" .. player:getAccountId() .. "', '" .. player:getGuid() .. "', NOW(), " .. db.escapeString(offer['title']) .. ", " .. db.escapeString(offer['cost']) .. ", " .. db.escapeString(json.encode(offer)) .. ")")
    return sendMessage(player, "Exito!", "Tu compraste " .. offer['title'] .."!", true)
  end
  if status == nil or status == false then
    status = "Error desconocido al comprar envia un correo a Contactovagosclub.cl@gmail.com o habla con el admin 'Arkathos'" .. offer['title']
  end
  sendMessage(player, "Error!", status)
end

function sendHistory(player)
  if player:getStorageValue(1150002) and player:getStorageValue(1150002) + 10 > os.time() then
    return -- min 10s delay
  end
  player:setStorageValue(1150002, os.time())

  local history = {}
	local resultId = db.storeQuery("SELECT * FROM `shop_history` WHERE `account` = " .. player:getAccountId() .. " order by `id` DESC")

	if resultId ~= false then
    repeat
      local details = result.getDataString(resultId, "details")
      local status, json_data = pcall(function() return json.decode(details) end)
      if not status then    
        json_data = {
          type = "image",
          title = result.getDataString(resultId, "title"),
          cost = result.getDataInt(resultId, "cost")
        }
      end
      table.insert(history, json_data)
      history[#history]["description"] = "comprado en " .. result.getDataString(resultId, "date") .. " por " .. result.getDataInt(resultId, "cost") .. " puntos."
    until not result.next(resultId)
    result.free(resultId)
	end

  sendJSON(player, "history", history)
end

-- BUY CALLBACKS
-- May be useful: print(json.encode(offer))

function defaultItemBuyAction(player, offer)
  -- todo: check if has capacity
  if player:addItem(offer["itemId"], offer["count"], false) then
    return true
  end
  return "No se puede agregar el articulo! Tienes suficiente espacio?"
end

function defaultPremiumBuyAction(player, offer)
	if player:getPremiumDays() + offer["count"] > 360 then
		return "No puedes comprar mas de 1 año premium"
	else
		player:addPremiumDays(offer["count"])
	return true
	end
return true
end

function defaultOutfitBuyAction(player, offer)
  local outfit = offer["outfit"]
  local outfitId = player:addOutfit(outfit["type"], outfit["id"], outfit["addons"], outfit["mount"])
  if outfitId ~= 0 then
    return true
  else
    return "No se pudo agregar el atuendo al jugador."
  end
end


function defaultImageBuyAction(player, offer)
  return "la accion de compra de imagen predeterminada no esta implementada"
end

function customImageBuyAction(player, offer)
  return "la accion de compra de imagen personalizada no esta implementada. Oferta: " .. offer['title']
end
