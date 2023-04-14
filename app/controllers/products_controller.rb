class ProductsController < ApplicationController
  before_action :redirect_to_root_if_not_log_in, except: [:index, :show, :products]
  before_action :prepare_index, only: [:index, :products, :show]
  before_action :get_products, only: [:index]
  before_action :create_pagination, only: [:index]

  LIMITED_PRODUCTS_NUMBER = 20

  def index
  end


  def show
    @product = Product.find_by_id(params[:id])
  end

  def new
    @product = Product.new
  end

  def create
    image = params[:product][:image]
    if image
      image_url = save_file(image)
    end

    product = Product.create(product_permit.merge({image_url: image_url}))
    flash[:notice] = "建立成功"
    redirect_to action: :new
  end

  def edit
    @product = Product.find_by_id(params[:id])
    if @product.blank?
      redirect_to root_path
      return
    end
  end

  def update
    product = Product.find(params[:id])

    image = params[:product][:image]
    if image
      image_url = save_file(image)
      product.update(product_permit.merge({image_url: image_url}))
    else
      product.update(product_permit)
    end

    product.update(product_permit.merge({image_url: image_url}))

    flash[:notice] = "更新成功"
    redirect_to action: :edit
  end

  def destroy
    product = Product.find(params[:id])
    product.destroy

    redirect_to action: :index
  end


  private

  def product_permit
    params.require(:product).permit([:name, :description, :price, :subcategory_id])
  end


  def redirect_to_root_if_not_log_in
    if !current_user || !current_user.is_admin?
      flash[:notice] = "您沒有權限"
      redirect_to root_path
      return
    end
  end


  def save_file(newFile)
    dir_url = Rails.root.join('public', 'uploads/products')

    FileUtils.mkdir_p(dir_url) unless  File.directory?(dir_url)

    file_url = dir_url + newFile.original_filename

    File.open(file_url, 'w+b') do |file|        #b = binary
      file.write(newFile.read)
    end

    return "/uploads/products/" + newFile.original_filename
  end

  def prepare_index
    create_ad
    get_current_page
    get_all_categories
  end

  def create_ad
    @ad = {
      title: "大型廣告" ,
      des: "這是廣告",
      action_title: "閱讀更多",
    }
  end

  def get_current_page
    if params[:page]                    #如果有點選頁面按鈕的話，params[:page] = 所選的頁數，如果沒有點選頁面按鈕的話，頁面就是在index，所以params[:page] = 1
      @page = params[:page].to_i
    else
      @page = 1
    end
  end

  def get_all_categories
    @categories = Category.includes(:subcategories).all         #includes(:xxx) 裡面要放的是該類別model表裡面 has_many :xxx 的symbol名稱   #這是在減少每次loading頁面時的select語句
  end
                                                                #model表裡面對應到的是belongs_to就放belongs_to的symbol名稱，對應到的是has_many就放has_many的symbol名稱
  def get_products
    @products = Product.includes(:subcategory).includes(:category).all             #includes(:xxx) 裡面要放的是該類別model表裡面 belongs_to :xxx 的symbol名稱  #這是在減少每次loading頁面時的select語句
  end

  def create_pagination
    count = @products.count
    @first_page = 1
    @last_page = ( count / LIMITED_PRODUCTS_NUMBER )
    if ( count % LIMITED_PRODUCTS_NUMBER > 0 )          #如果商品數量/20有餘數，代表需要多一頁來顯示剩餘商品，所以頁數要+1
      @last_page += 1
    elsif ( count == 0 )
      @last_page = 1
    end

    @products = @products.offset( (@page - 1) * LIMITED_PRODUCTS_NUMBER).limit(LIMITED_PRODUCTS_NUMBER)
  end
end
