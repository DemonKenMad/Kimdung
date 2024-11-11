--[[
    公共方法

    --By: haidong.gan
    --2013/11/11
]]
local Public = {}

local yueyu_id = "314|301|288|217|211|105|221|143|198|133|132|118|129|199|168|182|288"

function showLongLoading(isReconect)
    isReconect = isReconect or false;
    local currentScene = Public:currentScene()
    if not isReconect then
        if currentScene ~= nil and currentScene.getTopLayer then
            local toplayer = currentScene:getTopLayer()
            if toplayer == nil or toplayer.__cname == "ReconnectLayer" then
                return;
            end
        end
    end

    LoadingLayer:show(2);
end

function showLoading(isReconect)
    isReconect = isReconect or false;
    local currentScene = Public:currentScene()
    if not isReconect then
        if currentScene ~= nil and currentScene.getTopLayer then
            local toplayer = currentScene:getTopLayer()
            if toplayer == nil or toplayer.__cname == "ReconnectLayer" then
                return;
            end
        end
    end
    LoadingLayer:show();
end

function hideLoading()
    LoadingLayer:hide()
end

function hideAllLoading()
    LoadingLayer:clearForCuurentScene()
end

function createUIByLuaNew(uiPath)
   if BaseLayer.isDebug then
        TFDirector:unRequire(uiPath);
   end
   return createUIByLua(uiPath);
end

function requireNew(uiPath)
   if BaseLayer.isDebug then
        TFDirector:unRequire(uiPath);
   end
   return require(uiPath);
end

function Public:currentScene()
  local currentScene = nil;
  if me.Director.getNextScene then
      currentScene = me.Director:getNextScene();
  end
  if not currentScene then
      currentScene = me.Director:getRunningScene();
  end
  return currentScene;
end

function Public:createIconNumNode(rewardItem,isCanTouch)
    local node  = createUIByLuaNew("lua.uiconfig_mango_new.common.IconNumItem");
    self:loadIconNode(node,rewardItem,false,isCanTouch)
    return node;
end
function Public:createIconNumAndBagNode(rewardItem)
    local node  = createUIByLuaNew("lua.uiconfig_mango_new.common.IconNumItem");
    if rewardItem.type == EnumDropType.GOODS then
      self:loadIconBagNode(node,rewardItem)
    else
      self:loadIconNode(node,rewardItem,true)
    end
    return node;
end

function Public:createBgQualityNode(itemPath, quality)
    local node      = createUIByLuaNew("lua.uiconfig_mango_new.common.IconNumItem");
    local img_icon  = TFDirector:getChildByPath(node, 'img_icon');
    local txt_num   = TFDirector:getChildByPath(node, 'txt_num');
    local bg_icon   = TFDirector:getChildByPath(node, 'bg_icon');
    if (txt_num) then
      txt_num:setVisible(false)
    end
    if (img_icon) then
      img_icon:setTexture(itemPath)
    end
    bg_icon:setTextureNormal(GetColorIconByQuality_118(quality));
    return node;
end

function Public:createRewardNode(rewardItem)
    local node  = createUIByLuaNew("lua.uiconfig_mango_new.common.IconRewardItem");
    self:loadIconNode(node,rewardItem)
    return node;
end

function Public:isPiece(rewardItem)
    local isPiece = false;

    -- 蛇胆不添加碎片标示
    local itemId = rewardItem.itemid or rewardItem.itemId
    if itemId and itemId >= 3000 and itemId <= 3003 then
      return false,0
    end
    
    if (rewardItem.type == nil or rewardItem.type == EnumDropType.GOODS) and itemId then

        local item = ItemData:objectByID(itemId)
        if item.type == EnumGameItemType.Soul and item.kind ~= 3 then
            return true,EnumGameItemType.Soul ;
        elseif item.type == EnumGameItemType.Piece then
            return true,EnumGameItemType.Piece ;
        elseif item.type == EnumGameItemType.SkyBookPiece then
            return true,EnumGameItemType.SkyBookPiece ;
        elseif item.type == EnumGameItemType.SBStonePiece then
            return true,EnumGameItemType.SBStonePiece ;
        elseif item.type == EnumGameItemType.HeadPicFrame then
            return true,EnumGameItemType.HeadPicFrame ;
        elseif item.type == EnumGameItemType.StrategyPiece then
            return true, EnumGameItemType.StrategyPiece
        elseif item.type == EnumGameItemType.ItemPiece then
            return true, EnumGameItemType.ItemPiece
        end
    end
    return false,0;
end

function Public:addStarImg(img_icon,star,positionY)
    positionY = positionY or img_icon:getSize().height/2 - 8;
  	if star <= 5 then
    		for i=1,star do
      			local imgStar = img_icon:getChildByTag(10090 + i);
      			if not imgStar then 
        				imgStar = TFImage:create("ui_new/equipment/tjp_xingxing_icon.png");
        				imgStar:setTag(10090 + i);

                img_icon:addChild(imgStar);
            else
              imgStar:setTexture("ui_new/equipment/tjp_xingxing_icon.png");
            end
      			imgStar:setPosition(ccp(- img_icon:getSize().width/2 + 23 + 17 *(i-1) ,positionY));
    		end
    		for i=star + 1,5 do
      			local imgStar = img_icon:getChildByTag(10090 + i);
      			if imgStar then
      			   img_icon:removeChildByTag(10090 + i,true);
      			end
    		end
  	else
    		local delta = star - 5
    		for i = 1, 5 do
      			local imgStar = img_icon:getChildByTag(10090 + i);
      			if not imgStar then 
        				if i <= delta then
        					 imgStar = TFImage:create("ui_new/equipment/tjp_xingxing2_icon.png");
        				else
        					 imgStar = TFImage:create("ui_new/equipment/tjp_xingxing_icon.png");
        				end
        				imgStar:setTag(10090 + i);
        				imgStar:setPosition(ccp(- img_icon:getSize().width/2 + 23 + 17 *(i-1) ,positionY));

        				img_icon:addChild(imgStar);
      			else
        				if i <= delta then
        					 imgStar:setTexture("ui_new/equipment/tjp_xingxing2_icon.png");
        				else
        					 imgStar:setTexture("ui_new/equipment/tjp_xingxing_icon.png");
        				end				
      			end
    		end
  	end
end

function Public:addPieceImg(img_icon,rewardItem,isPiece,scale)
    if img_icon == nil then
        return
    end
    -- if scale == nil then
    --     scale = 0.94
    -- end
    scale = scale or 1
    local imgPiece = img_icon:getChildByTag(10087);
    if isPiece == nil then
        isPiece = self:isPiece(rewardItem);
    end
    if isPiece then
        local itemId    = rewardItem.itemid or rewardItem.itemId
        local item      = ItemData:objectByID(itemId)
        local quality   = item.quality
        local pieceRes  = "ui_new/common/icon_bg/s"..quality..".png"
      
        if not imgPiece then


            imgPiece = TFImage:create(pieceRes);
            if imgPiece == nil then
                imgPiece = TFImage:create("ui_new/common/icon_bg/s1.png")
            end
            -- imgPiece = TFImage:create("ui_new/common/icon_bg/pz_bg_zhezao_124.png");
            imgPiece:setTag(10087);
            imgPiece:setScale(scale)
            img_icon:addChild(imgPiece);
        -- imgPiece:setScale(img_icon:getSize().width/118)
        else
            imgPiece:setTexture(pieceRes)
        end
    else
        if imgPiece then 
            imgPiece:removeFromParent();
        end
    end
end

function Public:addFrameImg(img_icon,frameId,isAdd,offSetX,offSetY)
	local imgFrame = img_icon:getChildByTag(11011);
    if img_icon.headeffect ~= nil then 
        img_icon.headeffect:removeFromParent()
        img_icon.headeffect = nil
    end
	if isAdd == false then
		if imgFrame then
			imgFrame:removeFromParent();
		end
	else
    if frameId == nil then
        if imgFrame then
            imgFrame:removeFromParent();
        end
        return;
    end
    local frameData = HeadPicFrameData:objectByID(frameId)
    if frameData == nil or frameData.img == nil or frameData.img == "" then
      if imgFrame then
        imgFrame:removeFromParent();
      end
      return;
    end
		local frameRes  = "ui_new/team/" .. frameData.img .. ".png";
		if TFFileUtil:existFile(frameRes) == false then
			if imgFrame then
				imgFrame:removeFromParent();
			end
			return;
		end
		if not imgFrame then
			imgFrame = TFImage:create(frameRes);
			imgFrame:setTag(11011);
			img_icon:addChild(imgFrame);
		else
			imgFrame:setTexture(frameRes);
		end
	end
    local data = { pos = ccp(58, 55),offsetX = offSetX, offsetY = offSetY}
    Public:showHeadEffect(img_icon,frameId,data)
end

function Public:showHeadEffect(img_icon,frameId,data)
    if img_icon.headeffect ~= nil then 
        img_icon.headeffect:removeFromParent()
        img_icon.headeffect = nil
    end
    local frameData = HeadPicFrameData:objectByID(frameId)
    if frameData ~= nil and frameData.effect ~= nil and frameData.effect ~= "0" then
        TFResourceHelper:instance():addArmatureFromJsonFile("effect/head/"..frameData.effect..".xml")   
        local showeffect = TFArmature:create(frameData.effect.."_anim")
        -- if data and data.scale then
        --     showeffect:setScale(data.scale)
        -- end
        -- if data and data.offsetY then
        --     data.pos.y = data.pos.y + data.offsetY
        -- end
        -- if data and data.offsetX then
        --     data.pos.x = data.pos.x + data.offsetX
        -- end
        -- if data and data.pos then
        --     showeffect:setPosition(data.pos)
        -- end
        showeffect:setPositionType(1)
        showeffect:setPositionPercent(ccp(0.5, 0.5))
        showeffect:setAnimationFps(GameConfig.ANIM_FPS)
        showeffect:setVisible(true)
        img_icon:addChild(showeffect)        
        showeffect:playByIndex(0, -1, -1, 1)
        img_icon.headeffect = showeffect
    end  
end
function Public:getStarHeroEffect()
--   local imgName = "ui_new/crosszhenba/img_bz1.png"
--   local textPanel = TFImage:create(imgName)
--   textPanel:setScale(0.9)
  local resPath = "effect/star_hero_effect.xml"
  TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
  local effect = TFArmature:create("star_hero_effect_anim")
  effect:setAnimationFps(GameConfig.ANIM_FPS)
  return effect
end
function Public:getCrossZhengBaEffect( level )
  local textPanel = nil
  if level >= 16 and level <= 20 then
    textPanel = TFImage:create("ui_new/crosszhenba/img_bz2.png")
    textPanel:setScale(0.9)
  elseif level == 21 then
    textPanel = TFImage:create("ui_new/crosszhenba/img_bz3.png")
    textPanel:setScale(0.9)
  elseif level == 22 then
    textPanel = TFImage:create("ui_new/crosszhenba/img_bz4.png")
    textPanel:setScale(0.9)
  end
  return textPanel
end
function Public:addInfoListen(btn_frame,enabled,showType,playerId,serverId, isIsland)
    if nil == btn_frame then
        return
    elseif nil == playerId or nil == showType then
        btn_frame:setTouchEnabled(false)
        return
    end
    playerId = tonumber(playerId)
    btn_frame:setTouchEnabled(enabled)
    if enabled == false then
        return
    end
    if playerId == MainPlayer:getPlayerId() then
        btn_frame:setTouchEnabled(false)
        return
    end
    local callFunc = function (sender)
        if playerId <= 0 or playerId >= 1879048192 then
            return
        end
        if isIsland then
            JapanIslandManager:requestTeammateInfo(playerId)
        else
            OtherPlayerManager:requestPlayerInfo(showType,playerId,serverId)
        end
    end
    btn_frame:addMEListener(TFWIDGET_CLICK, audioClickfun(callFunc))
end

function Public:addLianTiEffect(node,quality,isAdd,scale,index)
    local effect = node.effect
    scale = scale or 1
    if isAdd == false then
        if effect then
            effect:removeFromParent();
            node.effect = nil
        end
    else
        if quality == nil or quality <= 0 then
            if effect then
                effect:removeFromParent();
                node.effect = nil
            end
            return
        end
        if effect == nil then
            print("addLianTiEffect")
            local resPath = "effect/lianti2_"..quality..".xml"
            if not TFFileUtil:existFile(resPath) then
                return
            end
            TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
            local effect = TFArmature:create("lianti2_"..quality.."_anim")
            effect:setScale(scale)
            -- effect:setAnimationFps(GameConfig.ANIM_FPS)
            local size = node:getContentSize()
            effect:setPosition(size.width*0.5,size.height*0.5)
            node:addChild(effect , 100)
            node.effect = effect
            node.effect.quality = quality
        else
            if node.effect.quality ~= quality then
                effect:removeFromParent();
                node.effect = nil
                local resPath = "effect/lianti2_"..quality..".xml"
                if not TFFileUtil:existFile(resPath) then
                    return
                end

                TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
                local effect = TFArmature:create("lianti2_"..quality.."_anim")
                effect:setScale(scale)
                -- effect:setAnimationFps(GameConfig.ANIM_FPS)
                local size = node:getContentSize()
                effect:setPosition(size.width*0.5,size.height*0.5)
                node:addChild(effect , 100)
                node.effect = effect
                node.effect.quality = quality
            end
        end
        if index == nil then
            index = 0
        end
        node.effect:playByIndex(index, -1, -1, 1)
    end
end

function Public:loadIconNode(node,rewardItem,isShowOne,isCanTouch)
    if isShowOne == nil then
        isShowOne = false
    end
    if isCanTouch == nil then
        isCanTouch = true
    end
    if node and rewardItem == nil then
        node:setVisible(false)
    end
    if node and rewardItem then
        node:setVisible(true)
        local img_icon  = TFDirector:getChildByPath(node, 'img_icon');
        local txt_num   = TFDirector:getChildByPath(node, 'txt_num');
        local txt_name  = TFDirector:getChildByPath(node, 'txt_name');
        local txt_namew  = TFDirector:getChildByPath(node, 'txt_namew');
        local bg_icon   = TFDirector:getChildByPath(node, 'bg_icon');

        if bg_icon then
            bg_icon:setTextureNormal(GetColorIconByQuality_118(rewardItem.quality));
            if isCanTouch then
                function onClick( sender )
                    Public:ShowItemTipLayer(rewardItem.itemid, rewardItem.type);
                end
                bg_icon:setTouchEnabled(true)
                bg_icon:addMEListener(TFWIDGET_CLICK, audioClickfun(onClick));
            else
                bg_icon:setTouchEnabled(false)
            end
        end
        if txt_name then
            txt_name:setText(rewardItem.name);
        end
        if txt_namew then
            -- txt_namew:setText(rewardItem.name)
            -- txt_namew:setVisible(false)

            local item_xinfa = XinFaManager:getItemById(rewardItem.itemid)
            local item_xinfapiece = BagManager:getItemById(rewardItem.itemid)
            -- 宝石做特殊处理
            if rewardItem.itemid and rewardItem.itemid > 1000 and rewardItem.itemid < 1056 then 
                img_icon:setScale(0.9)
            end
            local miaoshu = 0
            if item_xinfapiece and item_xinfapiece.itemdata then
                if item_xinfapiece.itemdata.type == 11 and item_xinfapiece.itemdata.kind == 1 then
                    miaoshu = 1
                end
            end
            if item_xinfa or miaoshu == 1 then  
                if txt_namew.textLabel then
                    txt_namew.textLabel:removeFromParent()
                    txt_namew.textLabel = nil
                end
                local textLabel = TFScrollRichText:create(rewardItem.name)
                textLabel:setSpecial(true)
                textLabel:setTextPos(ccp(-50, -30))
                textLabel:setZOrder(10)
                textLabel:setPosition(ccp(-50, -30)) 
                textLabel:setSize(CCSizeMake(80, 50))
                textLabel:setSpeed(0.3)
                textLabel:setScale(1.4)
                textLabel:setColor(ccc3(250,250,250))
                textLabel:setChangeFunc(txt_namew, NotifyManager:displayTuhaoChatCompelete())
                txt_namew:addChild(textLabel)
                txt_namew.textLabel = textLabel
                txt_namew:setText("  ")
            else
                txt_namew:setText(rewardItem.name);
            end
            txt_namew:setVisible(false)
        end
        if img_icon then
            img_icon:setTexture(rewardItem.path);
            self:addPieceImg(img_icon,rewardItem);
        end
        if txt_num then
            -- txt_num:setText("X" .. rewardItem.number);
            txt_num:setText(rewardItem.number);
            if rewardItem.number and rewardItem.number < 2 and isShowOne == false then
                txt_num:setVisible(false);
            else
                txt_num:setVisible(true);
            end
        end

        return node;
    end
end
function Public:loadIconBagNode(node,rewardItem)
   if node and rewardItem then
        if rewardItem.type ~= EnumDropType.GOODS then
            return Public:loadIconNode(node,rewardItem)
        end
        local img_icon  = TFDirector:getChildByPath(node, 'img_icon');
        local txt_num   = TFDirector:getChildByPath(node, 'txt_num');
        local txt_name  = TFDirector:getChildByPath(node, 'txt_name');
        local bg_icon   = TFDirector:getChildByPath(node, 'bg_icon');

        if bg_icon then
            bg_icon:setTextureNormal(GetColorIconByQuality_118(rewardItem.quality));
            function onClick( sender )
              Public:ShowItemTipLayer(rewardItem.itemid, rewardItem.type);
            end
            bg_icon:addMEListener(TFWIDGET_CLICK, audioClickfun(onClick));
        end
        if txt_name then
            txt_name:setText(rewardItem.name);
        end
        if img_icon then
            img_icon:setTexture(rewardItem.path);
            self:addPieceImg(img_icon,rewardItem);
        end
        if txt_num then
            local num_bag = BagManager:getItemNumById(rewardItem.itemid)
            txt_num:setText(num_bag.."/"..rewardItem.number);
            -- if rewardItem.number < 2 then
            --     txt_num:setVisible(false);
            -- else
            --     txt_num:setVisible(true);
            -- end
        end

        return node;
    end
end

function Public:createIconNameNumNode(rewardItem)
    local node  = createUIByLuaNew("lua.uiconfig_mango_new.common.IconNameItem");
    self:loadIconNode(node,rewardItem)
    return node;
end

function Public:indexAtArr(arr,item)
    for index,arrItem in ipairs(arr) do
        if arrItem == item then
            return index;
        end
    end
    return -1;
end


function Public:bindScrollFun(scrollView)

    function scrollView:bindScrollArrow(ui)
        local img_arrow_left        = TFDirector:getChildByPath(ui, 'img_arrow_left');
        local img_arrow_right       = TFDirector:getChildByPath(ui, 'img_arrow_right');
        local img_arrow_top         = TFDirector:getChildByPath(ui, 'img_arrow_top');
        local img_arrow_bottom      = TFDirector:getChildByPath(ui, 'img_arrow_bottom');

        if img_arrow_left then
            img_arrow_left:setVisible(false);
        end
        if img_arrow_right then
            img_arrow_right:setVisible(false);
        end
        if img_arrow_top then
            img_arrow_top:setVisible(false);
        end
        if img_arrow_bottom then
            img_arrow_bottom:setVisible(false);
        end
        
        local onUpdated = function(event)
            if img_arrow_left and img_arrow_right then
                local scrollViewWidth = (self.getTableViewSize and self:getTableViewSize().width) or self:getContentSize().width;
                local innerContainerWidth = (self.getInnerContainerSize and self:getInnerContainerSize().width) or self:getContentSize().width;
                local contentOffset = self:getContentOffset();

                if contentOffset.x > - 100 then
                    img_arrow_right:setVisible(false);
                else
                    img_arrow_right:setVisible(true);
                end

                if contentOffset.x < scrollViewWidth - innerContainerWidth + 100 then
                    img_arrow_left:setVisible(false);
                else
                    img_arrow_left:setVisible(true);
                end
            end

           if img_arrow_top and img_arrow_bottom then
                local scrollViewHeight =(self.getTableViewSize and self:getTableViewSize().height) or self:getContentSize().height;
                local innerContainerHeight = (self.getInnerContainerSize and self:getInnerContainerSize().height) or self:getContentSize().height;
           
                local contentOffset = self:getContentOffset();

                if contentOffset.y > - 100 then
                    img_arrow_top:setVisible(false);
                else
                    img_arrow_top:setVisible(true);
                end

                if contentOffset.y < scrollViewHeight - innerContainerHeight + 100 then
                    img_arrow_bottom:setVisible(false);
                else
                    img_arrow_bottom:setVisible(true);
                end
            end
        end;
        self.arrowIimer = TFDirector:addTimer(0.3, -1, nil, onUpdated); 
    end


    function scrollView:cancelScrollArrow()
        TFDirector:removeTimer(self.arrowIimer);
        self.onUpdated = nil;
    end


    --使某个位置，按X居中
    function scrollView:setInnerContainerSizeForHeight(height)
      local innerContainerSizeForHeight = height
      self:setInnerContainerSize(CCSizeMake(self:getInnerContainerSize().width,innerContainerSizeForHeight));

      local offsetY = self:getSize().height - height;
      if offsetY > 0 then
          local childrenArr = self:getChildren();
          for i=0,childrenArr:count()-1 do
              local child = childrenArr:objectAtIndex(i);
              child:setPosition(ccp(child:getPosition().x, child:getPosition().y + offsetY));
          end
      end
    end 

    --使某个位置，按X居中
    function scrollView:scrollToCenterForPositionX(forPositionX, dt)
       dt = dt or 0;
       local scrollViewWidth = (self.getTableViewSize and self:getTableViewSize().width) or self:getContentSize().width;
       local innerContainerWidth = (self.getInnerContainerSize and self:getInnerContainerSize().width) or self:getContentSize().width;

        --置左
       if(innerContainerWidth < scrollViewWidth) then
          self:setContentOffset(ccp(0, 0),dt);

        --底部1/2以下
       elseif forPositionX < scrollViewWidth/2 then
          self:setContentOffset(ccp(0, 0),dt);
       else
          local pt = math.max(scrollViewWidth/2 - forPositionX , scrollViewWidth - innerContainerWidth);
          self:setContentOffset(ccp(pt,0), dt);
       end 
    end 

    --使某个位置，按Y居中
    function scrollView:scrollToCenterForPositionY(forPositionY, dt)
       dt = dt or 0;
       local scrollViewHeight =(self.getTableViewSize and self:getTableViewSize().height) or self:getContentSize().height;
       local innerContainerHeight = (self.getInnerContainerSize and self:getInnerContainerSize().height) or self:getContentSize().height;
       
        --置顶
       if(innerContainerHeight < scrollViewHeight) then
          self:setContentOffset(ccp(0, scrollViewHeight - innerContainerHeight), dt);
        --底部1/2以下
       elseif forPositionY < scrollViewHeight/2 then
          self:setContentOffset(ccp(0, 0), dt);
       else
          local pt = math.max(scrollViewHeight/2 - forPositionY,scrollViewHeight - innerContainerHeight);
          self:setContentOffset(ccp(0, pt), dt);
       end 
    end 

    --纵向，滚动到最后一条
    function scrollView:scrollToYLast(dt)
       dt = dt or 0;  
       local scrollViewHeight = (self.getTableViewSize and self:getTableViewSize().height) or self:getContentSize().height;
       local innerContainerHeight = (self.getInnerContainerSize and self:getInnerContainerSize().height) or self:getContentSize().height;
       
       if(innerContainerHeight < scrollViewHeight) then
          self:setContentOffset(ccp(0, scrollViewHeight-innerContainerHeight), dt);
       else
          self:setContentOffset(ccp(0, 0), dt);
       end 
    end

    --纵向，滚动到第一条
    function scrollView:scrollToYTop(dt)
       dt = dt or 0;
       local scrollViewHeight = (self.getTableViewSize and self:getTableViewSize().height) or  self:getContentSize().height;
       local innerContainerHeight = (self.getInnerContainerSize and self:getInnerContainerSize().height) or self:getContentSize().height;
       
       self:setContentOffset(ccp(0, scrollViewHeight-innerContainerHeight), dt);
    end 

    --横向，滚动到最后一条
    function scrollView:scrollToXLast(dt)
       dt = dt or 0;
       local scrollViewWidth = (self.getTableViewSize and self:getTableViewSize().width) or self:getContentSize().width;
       local innerContainerWidth = (self.getInnerContainerSize and self:getInnerContainerSize().width) or self:getContentSize().width;

       if innerContainerWidth < scrollViewWidth then
           self:setContentOffset(ccp(0, 0), dt);   
       else
           self:setContentOffset(ccp(scrollViewWidth-innerContainerWidth, 0), dt);
       end 
    end 

    --横向，滚动到第一条
    function scrollView:scrollToXTop(dt)
       dt = dt or 0;
       local scrollViewWidth = (self.getTableViewSize and self:getTableViewSize().width) or self:getContentSize().width;
       local innerContainerWidth = (self.getInnerContainerSize and self:getInnerContainerSize().width) or self:getContentSize().width;

       self:setContentOffset(ccp(0, 0), dt);
    end


    --纵向，滚动的百分比
    function scrollView:getScrollYPercent()
        local contentOffset = self:getContentOffset();
        local innerContainerHeight = (self.getInnerContainerSize and self:getInnerContainerSize().height) or self:getContentSize().height;
        local percent = contentOffset.y/innerContainerHeight*(-1)
        percent = percent <= 1 and percent or 1
        return math.floor(percent*100)
    end
    --横向，滚动的百分比
    function scrollView:getScrollXPercent()
        local contentOffset = self:getContentOffset();
        local innerContainerWidth = (self.getInnerContainerSize and self:getInnerContainerSize().width) or self:getContentSize().width;
        local percent = contentOffset.x/innerContainerWidth*(-1)
        percent = percent <= 1 and percent or 1
        return math.floor(percent*100)
    end
end

--打开物品或卡牌描述界面 itemID：物品或卡牌模板id，type：1物品 2卡牌
function Public:ShowItemTipLayer(itemID, type, num,level)
    local desLayer = AlertManager:getLayerByName("lua.logic.item.ItemTipLayer")
    if desLayer then
        return
    end
    local layer = AlertManager:addLayerToQueueAndCacheByFile("lua.logic.item.ItemTipLayer",AlertManager.BLOCK_AND_GRAY,AlertManager.TWEEN_1)
    layer.toScene = TFDirector:currentScene()
    layer:loadData({itemID, type, num});
    AlertManager:show()
    if level then
        layer:setTipText("LV" .. level)
    end
end


function Public:addBtnWaterEffect(node, bAdd,index)
    if bAdd then
        if node.effect == nil then
            print("addBtnEffect")
            
            local resPath = "effect/ui/btn_water_effect.xml"
            if not TFFileUtil:existFile(resPath) then
                return
            end
            
            TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
            local effect = TFArmature:create("btn_water_effect_anim")
            -- effect:setAnimationFps(GameConfig.ANIM_FPS)
            node:addChild(effect , 100)
            node.effect = effect
        end
        -- index == 1 === > HD改了特效之后index = 1播不了
        if index == nil or index == 1 then
            index = 0
        end
        node.effect:playByIndex(index, -1, -1, 1)
        return node.effect
    else
        if node.effect then
            node.effect:removeFromParent()
            node.effect = nil
        end
    end
end

--added by wuqi
function Public:addVipEffect(btn, vipLevel, scale)
    if btn.effect then
        btn.effect:removeFromParent()
        btn.effect = nil
    end

    if not scale then
        scale = 1
    end

    vipLevel = tonumber(vipLevel)
    if vipLevel <= 15 or vipLevel > 18 then
        return
    end
    local resPath = "effect/ui/vip_" .. vipLevel .. ".xml"
    if not TFFileUtil:existFile(resPath) then
        return
    end
    TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
    local effect = TFArmature:create("vip_" .. vipLevel .. "_anim")
    effect:setAnimationFps(GameConfig.ANIM_FPS)
    effect:setPosition(ccp(btn:getContentSize().width / 2, btn:getContentSize().height / 2))
    effect:setVisible(true)
    effect:setScale(scale)
    effect:playByIndex(0, -1, -1, 1)
    btn:addChild(effect, 200)
    btn.effect = effect
end

function Public:showAttributeMove( node, equip )
  if node == nil then
    return nil
  end
  if node.moveTween then
    TFDirector:killTween(node.moveTween)
    node.moveTween = nil
    node:setPositionY(node.initPosY)
  end
  
  if node.initPosY == nil then
    node.initPosY = node:getPositionY()
  end
  if equip == nil then
    return nil
  end
  --附加属性
  local extraAttr,indexTable = equip:getExtraAttributeWithRecast():getAttribute()
  local notEmptyIndex = 1
  for k,i in pairs(indexTable) do
      if extraAttr[i] then
          notEmptyIndex = notEmptyIndex + 1
      end
  end
  local extraAttr = equip:getOrderLevelAttribute():getAttribute()
  if extraAttr then
    for k,v in pairs(extraAttr) do
          notEmptyIndex = notEmptyIndex + 1
    end
  end
  local currBreachLevel = equip:getorderBreachLevel()
  local CurrSpecialInfo = EquipmentSpecialAttribData:getDetailsByQualityLevel(equip.equipType, equip.quality, currBreachLevel)
  if CurrSpecialInfo then
    notEmptyIndex = notEmptyIndex + 2
  end
  local limitAttrNum = 5
  if notEmptyIndex > limitAttrNum then    
    local moveDy = (notEmptyIndex - limitAttrNum)*30
    local posY = node.initPosY
    local moveTween = 
      {
          target = node,
          repeated = -1,
          {
              duration = 2,
              delay = 1,
              y = posY + moveDy,
                      
          },
          { -- 此节实现节与节之间的延时
            duration = 1,
            delay = 1, 
            onComplete = function()
                  node:setPositionY(posY)
              end    
          },
      }
    TFDirector:toTween(moveTween)
    node.moveTween = moveTween
  end
end

function Public:showOrderDetailInfo(pannl_node,  equip, offsetY)
    --添加装备升阶获得的属性
    local txt_order_attr   = {}
    local txt_order_attr_val = {}
    for i = 1,EquipmentManager.orderAddAttrNum do
        txt_order_attr[i]          = TFDirector:getChildByPath(pannl_node, "txt_order_" .. i)
        txt_order_attr_val[i]      = TFDirector:getChildByPath(pannl_node, "txt_order_num_" .. i)
        txt_order_attr[i]:setVisible(false)
    end
    local txt_xiajiexiaoguo = TFDirector:getChildByPath(pannl_node, "txt_xiajiexiaoguo")
    txt_xiajiexiaoguo:setVisible(false)
    --添加装备升阶获得的属性
    local extraAttr = equip:getOrderLevelAttribute():getAttribute()
    local notEmptyIndex = 1
    if extraAttr then        
        local orderModeNode = TFDirector:getChildByPath(pannl_node, "panel_order")
        orderModeNode:setPositionY(offsetY)

        for k,v in pairs(extraAttr) do
            txt_order_attr[notEmptyIndex]:setVisible(true)
            txt_order_attr_val[notEmptyIndex]:setVisible(true)
        
            txt_order_attr[notEmptyIndex]:setText(AttributeTypeStr[k])
            txt_order_attr_val[notEmptyIndex]:setText("+ " .. covertToDisplayValue(k,v))
            notEmptyIndex = notEmptyIndex + 1
        end
    end

  local currBreachLevel = equip:getorderBreachLevel()
  local CurrSpecialInfo = EquipmentSpecialAttribData:getDetailsByQualityLevel(equip.equipType, equip.quality, currBreachLevel)
  if CurrSpecialInfo then
    local posY = txt_order_attr[notEmptyIndex]:getPositionY() + 10
    txt_xiajiexiaoguo:setPositionY(posY)
    txt_xiajiexiaoguo:setVisible(true)
    txt_xiajiexiaoguo:setText(CurrSpecialInfo.des)
  end
end

function Public:addZhenFaIconForArmy(pannl_node, type , isShow)
    if isShow == nil then
        isShow = true
    end
    local iconBg = {}
    for i=1,9 do
        iconBg[i] = TFDirector:getChildByPath(pannl_node, "img_zf"..i)
        if iconBg[i] then
            iconBg[i]:setVisible(false)
        end
    end
    local strategyCard = StrategyCardManager:getStrategyCardByStrategyType(type)
    if strategyCard == nil then
        print("unEquip card by type = ",type)
        return
    end
    local posNumber = strategyCard:getOpenPositionNumber()
    local strategyPos = strategyCard:getSrategyPos()
    for k,v in pairs(strategyPos) do
        if v <= posNumber then
            if iconBg[k] and isShow then
                iconBg[k]:setVisible(true) 
                -- iconBg[k]:setTexture("ui_new/zhenfa/img_"..v..".png")
            end
        end
    end
end

function Public:addZhenFaIconRukou(pannl_node, type, canTouch)

    local limitLevel = 130
    if canTouch and pannl_node.touchFlag == nil then
        local function nodeTouchCallBack( btn )
            if StrategyCardManager:checkIsOpen() then
               StrategyCardManager:openCardDressLayerByType(type)
            else
                print('暂未开放')
                return
            end
            
        end
        pannl_node:setTouchEnabled(true)
        pannl_node:addMEListener(TFWIDGET_CLICK,  audioClickfun(nodeTouchCallBack))
        pannl_node.touchFlag = true
    else
        pannl_node:setTouchEnabled(false)
    end
    local quality = TFDirector:getChildByPath(pannl_node, "img_quality")
    local equipIcon = TFDirector:getChildByPath(pannl_node, "img_equip")
    local addIcon = TFDirector:getChildByPath(pannl_node, "img_add")
    local lockIcon = TFDirector:getChildByPath(pannl_node, "img_lock")
    
    if StrategyCardManager:checkIsOpen() == false then
        quality:setVisible(false)
        equipIcon:setVisible(false)
        addIcon:setVisible(false)
        lockIcon:setVisible(true)
        return
    end
    local card = StrategyCardManager:getStrategyCardByStrategyType(type)
    if card == nil then
        quality:setVisible(false)
        equipIcon:setVisible(false)

        addIcon:setVisible(false)
        lockIcon:setVisible(false)
        return
    end
    quality:setVisible(true)
    quality:setTextureNormal(GetColorIconByQuality_118(card:getQuality()))
    equipIcon:setVisible(true)
    equipIcon:setTexture(card:getPath())
    addIcon:setVisible(false)
    lockIcon:setVisible(false)
end

function Public:addSelectIconForStrategyCard(panel, visible)
    if panel.img_select == nil then
        local img_select = TFImage:create("ui_new/roleequip/js_zbkxuanzhong_icon.png")
        panel:addChild(img_select)
        panel.img_select = img_select
    end
    panel.img_select:setVisible(visible)
end

function Public:addChangeLayerEffect( callFunc , effect_name )
    -- happy add
    if self.changeLayerPanel then
        --存在过渡动画 
        return
    end
    --happy add end
    if effect_name == nil then
        effect_name = "changLayerEffect"
    end
    local resPath = "effect/" .. effect_name..".xml"
    if not TFFileUtil:existFile(resPath) then
        return
    end
    TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
    local effect = TFArmature:create(effect_name .. "_anim")
    if effect == nil then
        if callFunc then
            TFFunction.call(callFunc)
        end
        return
    end
    local currentScene = Public:currentScene()
    local maskPanel = TFPanel:create()


    maskPanel:setSize(ccs(GameConfig.WS.width, GameConfig.WS.height))
    -- maskPanel:setBackGroundColorType(TF_LAYOUT_COLOR_SOLID)
    -- maskPanel:setBackGroundColor(ccc3(0, 0, 0))
    maskPanel:setTouchEnabled(true)
    maskPanel:setZOrder(1000)

    -- effect:setZOrder(1000)
    effect:setAnimationFps(GameConfig.ANIM_FPS)
    effect:playByIndex(0, -1, -1, 0)
    effect:setPosition(ccp(GameConfig.WS.width/2, GameConfig.WS.height/2))
    -- maskPanel:setPosition(ccp(GameConfig.WS.width/2, GameConfig.WS.height/2))

    self.cloudFuncCalled = false
    local temp = 1
    effect:addMEListener(TFARMATURE_UPDATE, function()
        temp = temp + 1
        if temp == 15 then
            if callFunc and not self.cloudFuncCalled then
                TFFunction.call(callFunc)
                self.cloudFuncCalled = true
            end
        elseif temp == 16 then
            effect:playByIndex(1, -1, -1, 0)
        -- elseif temp == 30 then
        --     effect:setVisible(false)
        --     effect:removeFromParent()
        --     effect = nil
        if callFunc and not self.cloudFuncCalled then
                self.cloudFuncCalled = true
                TFFunction.call(callFunc)
            end
        end
    end)
    effect:addMEListener(TFARMATURE_COMPLETE, function()
        if maskPanel then
            maskPanel:removeFromParent()
            maskPanel = nil
        end
        self.changeLayerPanel = nil
        if not self.cloudFuncCalled then
            if callFunc then
                TFFunction.call(callFunc)
                self.cloudFuncCalled = true
            end
        end
        TFDirector:dispatchGlobalEventWith(AdventureManager.changeLayerComplete, {})  
    end)
    maskPanel:addChild(effect)
    currentScene:addChild(maskPanel);
    self.changeLayerPanel = maskPanel
end

function Public:preloadLayerChangeEffect()
    --迷雾特效
    local effect_name = "changLayerEffect"

    local resPath = "effect/" .. effect_name..".xml"
    if not TFFileUtil:existFile(resPath) then
        return
    end
    TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
    --角色背景特效
    for i = 1, 3 do
        effect_name = "starLev" .. i .. "_up"
        resPath = "effect/" .. effect_name..".xml"
        if not TFFileUtil:existFile(resPath) then
            return
        end
        TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
        effect_name = "starLev" .. i .. "_down"
        resPath = "effect/" .. effect_name..".xml"
        if not TFFileUtil:existFile(resPath) then
            return
        end
        TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
    end
end

--只有橙色品质，且星级大于等于5才加特效
function Public:addRoleBgEffect(effectType, node, star, quality, data)
    local effectStar1 = 5
    local effectStar2 = 7
    local effectStar3 = 10

    local function getEffectLevel()
        local lev = 0
        if star and star >= 5 then
            if star >= effectStar3 then
                lev = 3
            elseif star >= effectStar2 then
                lev = 2
            else
                lev = 1
            end
        end
        return lev
    end
    if not node then
        return
    end
    if effectType == 1 and node.bgUpEffect then
        node.bgUpEffect:removeFromParent()
        node.bgUpEffect = nil
    end
    if effectType == 2 and node.bgDownEffect then
        node.bgDownEffect:removeFromParent()
        node.bgDownEffect = nil
    end

    if (not quality) or (quality < 5) then
        return
    end

    local starLev = getEffectLevel() or 0
    if starLev == 0 then
        return
    end
    local nameUp = "starLev" .. starLev .. "_up"
    local nameDown = "starLev" .. starLev .. "_down"
    local upEffectStr = "effect/" .. nameUp .. ".xml"
    local downEffectStr = "effect/" .. nameDown .. ".xml"
    if effectType == 1 then
    if not TFFileUtil:existFile(upEffectStr) then
        return
    end
        TFResourceHelper:instance():addArmatureFromJsonFile(upEffectStr)
    else
    if not TFFileUtil:existFile(downEffectStr) then
        return
    end
        TFResourceHelper:instance():addArmatureFromJsonFile(downEffectStr)
    end
    local effectUp, effectDown = nil, nil
    if effectType == 1 then
        effectUp = TFArmature:create(nameUp .. "_anim")
    else
        effectDown = TFArmature:create(nameDown .. "_anim")
    end

    if data and data.scale then
        if effectType == 1 then
            effectUp:setScale(data.scale)
        else
            effectDown:setScale(data.scale)
        end
    end

    local nodeSize = node:getSize()

    if effectType == 1 then
        if data and data.posUp then
            effectUp:setPosition(data.posUp)
        else
            effectUp:setPosition(nodeSize.width / 2, nodeSize.height / 2 - 130)
        end
        node.bgUpEffect = effectUp
        if data and data.zorder then
            effectUp:setZOrder(data.zorder)
        end
        node:addChild(effectUp)
        effectUp:playByIndex(0, -1, -1, 1)
    else
        if data and data.posDown then
            effectDown:setPosition(data.posDown)
        else
            effectDown:setPosition(nodeSize.width / 2, nodeSize.height / 2 - 230)
        end
        node.bgDownEffect = effectDown
        if data and data.zorder then
            effectDown:setZOrder(data.zorder)
        end
        node:addChild(effectDown)
        effectDown:playByIndex(0, -1, -1, 1)
    end
end



--富文本
function Public:createRichtextHB(_text, txt, setPosType, isAdd,fontSizeFlag)
    txt = txt or ""
    local panel = _text:getParent()
    if (panel == nil ) then return nil end
    local richtextHB = panel:getChildByName("_richtextHB")
    if (richtextHB ~= nil) then
        richtextHB:setText(txt) 
        return richtextHB 
    end
    local size = _text:getSize()
    richtextHB = TFRichText:create(size)
    richtextHB:setName("_richtextHB")
    if not fontSizeFlag then
        richtextHB:setFontSize(_text:getFontSize())
    end
    
    if (setPosType == EnumRichtextType.ItemTip) then
        --通用描述框
        local pos = _text:getPosition()
        richtextHB:setAnchorPoint(ccp(0, 1))
        richtextHB:setPosition(ccp(pos.x, pos.y + size.height))
    elseif (setPosType == EnumRichtextType.ShopOrUse) then
        --购买、使用描述框
        richtextHB:setAnchorPoint(ccp(0, 0.5))
        local pos = _text:getPosition()
        richtextHB:setPosition(ccp(pos.x, pos.y - size.height / 2))
    else
        richtextHB:setPosition(_text:getPosition())
        richtextHB:setAnchorPoint(_text:getAnchorPoint())  
    end
    richtextHB:setText(txt)
    if (isAdd ~= true) then
        panel:addChild(richtextHB, _text:getZOrder())
    end
    _text:setVisible(false)
    return richtextHB
end

function Public:getRechargeList()
    self.rechargeList = nil
    if CC_TARGET_PLATFORM == CC_PLATFORM_IOS then
        if HeitaoSdk then
            local platformid = HeitaoSdk.getplatformId()
            platformid = tonumber(platformid)
            local platformidList = string.split(yueyu_id, '|')
            for k,v in pairs(platformidList) do
                if platformid == tonumber(v) then
                    self.rechargeList = require("lua.table.t_s_recharge");
                    return self.rechargeList
                end
            end
        end
        self.rechargeList = require("lua.table.t_s_recharge_ios");
    else
        self.rechargeList = require("lua.table.t_s_recharge");
    end
    return self.rechargeList
end

--其他界面
function Public:OtherPlayEffectOnRole(roleArmature,EquipmentList,data)
    do return end
    if roleArmature.playeffect and type(roleArmature.playeffect) == "table" and next(roleArmature.playeffect) ~= nil then
        -- for i = 1,#roleArmature.playeffect do
        for k,v in pairs(roleArmature.playeffect) do
            if roleArmature.playeffect[i] ~= nil then 
                roleArmature.playeffect[i]:removeFromParent()
                roleArmature.playeffect[i] = nil
            end
        end
    end
    roleArmature.playeffect = {}
    if EquipmentList == nil then
        return
    end
    for id,num in pairs(EquipmentList) do
        if id%2 == 0 then
            local resPath = SuitsData:getSuitEffect(index,num)
            if resPath ~= nil and resPath ~= "0" then
                local effectRes = "effect/ui/"..resPath..".xml"
                TFResourceHelper:instance():addArmatureFromJsonFile(effectRes)
                if  TFFileUtil:existFile(effectRes) then
                    local effect = TFArmature:create(resPath.."_anim")
                    effect:setAnimationFps(GameConfig.ANIM_FPS)
                    if data and data.scale then
                        effect:setScale(data.scale)
                    end
                    if data and data.pos then
                        effect:setPosition(data.pos)
                    end
                    effect:setVisible(true)
                    roleArmature:addChild(effect,2)        
                    effect:playByIndex(0, -1, -1, 1)
                    roleArmature.playeffect[id%2] = effect
                end
            end
        else
            index = num
        end  
    end 
end
--检测是否包含符号
function Public:checkRoleNameSymbol(strName)
    local regexStr = [[^[a-z0-9A-Z\u4e00-\u9fa5]+$]]
    if string.find(strName, regexStr) then
        return true
    end
    return false
end

--检测玩家名字是否合法
function Public:isRoleNameLegal(strName)
  if (not strName) or strName == "" then
    toastMessage(localizable.createPlayer_input_player)
    return false
  end
  -- if self:checkRoleNameSensitive(strName) then
  --   toastMessage(localizable.player_invalide_name)
  --   return false
  -- end

  if type(strName) == "string" and string.utf8len(strName) > 16 then
    toastMessage(localizable.player_name_too_long)
    return false
  end

  if self:checkRoleNameSymbol(strName) then
    toastMessage(localizable.player_name_include_symbol)
    return false
  end
  return true
end
return Public;